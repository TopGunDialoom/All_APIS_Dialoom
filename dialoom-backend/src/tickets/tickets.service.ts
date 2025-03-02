import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ticket } from './ticket.entity';

@Injectable()
export class TicketsService {
  constructor(
    @InjectRepository(Ticket) private ticketRepo: Repository<Ticket>
  ) {}

  async create(userId: number, subject: string, message: string) {
    const ticket = this.ticketRepo.create({ userId, subject, message, status: 'open' });
    return this.ticketRepo.save(ticket);
  }

  async listForUser(userId: number) {
    return this.ticketRepo.find({ where: { userId } });
  }

  async updateStatus(id: number, status: string) {
    await this.ticketRepo.update({ id }, { status });
    return this.ticketRepo.findOne({ where: { id } });
  }
}
