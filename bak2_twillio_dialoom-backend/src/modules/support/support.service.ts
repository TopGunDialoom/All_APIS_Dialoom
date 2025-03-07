import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ticket } from './entities/ticket.entity';
import { Message } from './entities/message.entity';
import { User } from '../users/entities/user.entity';

@Injectable()
export class SupportService {
  constructor(
    @InjectRepository(Ticket) private ticketRepo: Repository<Ticket>,
    @InjectRepository(Message) private messageRepo: Repository<Message>,
  ) {}

  async createTicket(userId: number, subject: string): Promise<Ticket> {
    const ticket = this.ticketRepo.create({
      subject,
      user: { id: userId } as User
    });
    return this.ticketRepo.save(ticket);
  }

  async postMessage(ticketId: number, senderId: number, content: string): Promise<Message> {
    const ticket = await this.ticketRepo.findOne({ where: { id: ticketId } });
    if (!ticket) {
      throw new NotFoundException('Ticket no existe');
    }
    const newMsg = this.messageRepo.create({
      ticket, // Ticket no es null
      sender: { id: senderId } as User,
      content
    });
    return this.messageRepo.save(newMsg);
  }
}
