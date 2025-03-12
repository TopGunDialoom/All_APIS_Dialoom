import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Report } from './report.entity';
import { User } from '../../users/entities/user.entity';

@Injectable()
export class ModerationService {
  constructor(
    @InjectRepository(Report) private readonly reportRepo: Repository<Report>,
    @InjectRepository(User) private readonly userRepo: Repository<User>,
  ) {}

  // Crear un reporte
  async createReport(
    reporterId: number,
    accusedId: number,
    reason: string,
    details?: string,
  ): Promise<Report> {
    if (!reason) {
      throw new BadRequestException('Reason is required');
    }
    const reporter = await this.userRepo.findOne({ where: { id: reporterId } });
    if (!reporter) {
      throw new NotFoundException('Reporter user not found');
    }
    let accused: User = null;
    if (accusedId) {
      accused = await this.userRepo.findOne({ where: { id: accusedId } });
      if (!accused) {
        throw new NotFoundException('Accused user not found');
      }
    }
    const report = this.reportRepo.create({
      reporter,
      accused,
      reason,
      details,
      status: 'pending',
    });
    return this.reportRepo.save(report);
  }

  // Listar reportes (para admin)
  async findAllReports(): Promise<Report[]> {
    return this.reportRepo.find({
      relations: ['reporter', 'accused'],
      order: { createdAt: 'DESC' },
    });
  }

  // Ver un reporte puntual
  async findOneReport(id: number): Promise<Report> {
    const rpt = await this.reportRepo.findOne({
      where: { id },
      relations: ['reporter', 'accused'],
    });
    if (!rpt) throw new NotFoundException('Report not found');
    return rpt;
  }

  // Actualizar el estado o la acción
  async updateReport(id: number, updates: Partial<Report>): Promise<Report> {
    const rpt = await this.findOneReport(id);
    Object.assign(rpt, updates);
    return this.reportRepo.save(rpt);
  }

  // Posible método para banear
  async banUser(userId: number, reason: string) {
    // Lógica de baneo: user.isBanned = true, etc.
    // O user.status = 'banned'.
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User to ban not found');
    // supondremos que la entidad user tiene un campo isBanned: boolean
    user['isBanned'] = true;
    await this.userRepo.save(user);
    // Podríamos crear un "report" interno con action=ban
    return user;
  }
}
