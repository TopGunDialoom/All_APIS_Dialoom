import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Reservation } from './reservation.entity';
import { User } from '../users/user.entity';
import { NotificationService } from '../notifications/notification.service';
import { CreateReservationDto } from './dto/create-reservation.dto';

@Injectable()
export class ReservationsService {
  constructor(
    @InjectRepository(Reservation) private reservationRepo: Repository<Reservation>,
    @InjectRepository(User) private userRepo: Repository<User>,
    private notificationService: NotificationService
  ) {}

  async create(userId: number, dto: CreateReservationDto): Promise<Reservation> {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    const newRes = this.reservationRepo.create({
      date: new Date(dto.date),
      description: dto.description || '',
      user
    });
    const saved = await this.reservationRepo.save(newRes);
    // Sumar puntos
    if (user) {
      user.points += 10;
      await this.userRepo.save(user);
    }
    // Notificar
    await this.notificationService.notifyReservationCreated(saved);
    return saved;
  }

  async findForUser(userId: number): Promise<Reservation[]> {
    return this.reservationRepo.find({ where: { user: { id: userId } } });
  }
}
