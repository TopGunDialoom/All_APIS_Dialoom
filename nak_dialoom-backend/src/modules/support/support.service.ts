import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ticket, TicketStatus } from './entities/ticket.entity';
import { Message } from './entities/message.entity';
import { UsersService } from '../users/users.service';

@Injectable()
export class SupportService {
  constructor(
    @InjectRepository(Ticket) private ticketRepo: Repository<Ticket>,
    @InjectRepository(Message) private messageRepo: Repository<Message>,
    private usersService: UsersService,
  ) {}

  async createTicket(userId: number, subject: string): Promise<Ticket> {
    const user = { id: userId } as any;
    const ticket = this.ticketRepo.create({ user, subject });
    return this.ticketRepo.save(ticket);
  }

  async postMessage(ticketId: number, senderId: number, content: string): Promise<Message> {
    const ticket = await this.ticketRepo.findOne({ where: { id: ticketId } });
    const sender = await this.usersService.findById(senderId);
    const message = this.messageRepo.create({ ticket, sender, content });
    return this.messageRepo.save(message);
  }

  async closeTicket(ticketId: number) {
    await this.ticketRepo.update(ticketId, { status: TicketStatus.CLOSED });
  }

  async listTickets(): Promise<Ticket[]> {
    return this.ticketRepo.find({ relations: ['user'] });
  }

  async getMessages(ticketId: number): Promise<Message[]> {
    return this.messageRepo.find({ where: { ticket: { id: ticketId } }, relations: ['sender'] });
  }
}
