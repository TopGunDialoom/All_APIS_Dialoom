import { Injectable, NotFoundException, BadRequestException, Inject, forwardRef } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Reservation } from './reservation.entity';
import { ConfigService } from '@nestjs/config';
import { User } from '../users/entities/user.entity';

// Agora token generation
import { RtcRole, RtcTokenBuilder } from 'agora-access-token';
// "agora-access-token" ^2.0.0 (ya está en package.json)

@Injectable()
export class ReservationsService {
  constructor(
    @InjectRepository(Reservation)
    private reservationRepo: Repository<Reservation>,
    private configService: ConfigService,
  ) {}

  async createReservation(userId: number, mentorId: number, startTime: Date, duration: number = 60): Promise<Reservation> {
    // Podrías verificar disponibilidad de mentor, etc.
    // Lógica simplificada:
    const newRes = this.reservationRepo.create({
      user: { id: userId } as User,
      mentor: { id: mentorId } as User,
      startTime,
      durationMinutes: duration,
      status: 'PENDING'
    });
    return await this.reservationRepo.save(newRes);
  }

  async confirmReservation(resId: number): Promise<Reservation> {
    const res = await this.reservationRepo.findOne({ where: { id: resId }, relations: ['user', 'mentor'] });
    if (!res) {
      throw new NotFoundException('Reservation not found');
    }
    // Cambiar estado a CONFIRMED, generar agoraChannel
    res.status = 'CONFIRMED';
    res.agoraChannel = `dialoom_res_${res.id}`; // canal para la llamada
    return await this.reservationRepo.save(res);
  }

  async cancelReservation(resId: number): Promise<Reservation> {
    const res = await this.reservationRepo.findOne({ where: { id: resId } });
    if (!res) {
      throw new NotFoundException('Reservation not found');
    }
    res.status = 'CANCELLED';
    return await this.reservationRepo.save(res);
  }

  async getReservation(id: number): Promise<Reservation> {
    const r = await this.reservationRepo.findOne({
      where: { id },
      relations: ['user', 'mentor']
    });
    if (!r) {
      throw new NotFoundException('Reservation not found');
    }
    return r;
  }

  async getAllReservations(): Promise<Reservation[]> {
    return this.reservationRepo.find({
      relations: ['user', 'mentor']
    });
  }

  // Generar token de Agora con el appID, appCert de config
  generateAgoraToken(channelName: string, userId: string | number, role: RtcRole = RtcRole.PUBLISHER): string {
    const agoraAppId = this.configService.get<string>('AGORA_APP_ID');
    const agoraCert = this.configService.get<string>('AGORA_APP_CERT');
    if (!agoraAppId || !agoraCert) {
      throw new BadRequestException('Agora credentials not configured');
    }
    const expireTimeSeconds = 2 * 60 * 60; // 2 horas
    const currentTimestamp = Math.floor(Date.now() / 1000);
    const privilegeExpiredTs = currentTimestamp + expireTimeSeconds;

    const token = RtcTokenBuilder.buildTokenWithUid(
      agoraAppId,
      agoraCert,
      channelName,
      String(userId),
      role,
      privilegeExpiredTs
    );
    return token;
  }

  // Generar tokens para user y mentor
  async getCallTokens(resId: number, requestingUserId: number) {
    const res = await this.reservationRepo.findOne({
      where: { id: resId },
      relations: ['user', 'mentor']
    });
    if (!res) throw new NotFoundException('Reservation not found');
    if (res.status !== 'CONFIRMED') {
      throw new BadRequestException('Reservation not confirmed');
    }
    // Verifica si requestingUserId es user o mentor
    if (
      res.user.id !== requestingUserId &&
      res.mentor.id !== requestingUserId
    ) {
      throw new BadRequestException('No access to this reservation');
    }
    // canal = res.agoraChannel
    const userToken = this.generateAgoraToken(res.agoraChannel, requestingUserId, RtcRole.PUBLISHER);
    return {
      channelName: res.agoraChannel,
      token: userToken,
      expiration: 2 * 60 * 60 // 2h
    };
  }

  async completeReservation(resId: number): Promise<Reservation> {
    const res = await this.reservationRepo.findOne({ where: { id: resId } });
    if (!res) throw new NotFoundException('Reservation not found');
    res.status = 'COMPLETED';
    return this.reservationRepo.save(res);
  }
}
