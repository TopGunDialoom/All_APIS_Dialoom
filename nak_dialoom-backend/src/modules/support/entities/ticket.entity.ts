import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, OneToMany } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Message } from './message.entity';

export enum TicketStatus {
  OPEN = 'open',
  CLOSED = 'closed'
}

@Entity()
export class Ticket {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 200 })
  subject: string;

  @Column({ type: 'enum', enum: TicketStatus, default: TicketStatus.OPEN })
  status: TicketStatus;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  user: User; // usuario que creó el ticket

  @CreateDateColumn()
  createdAt: Date;

  @OneToMany(() => Message, (message) => message.ticket)
  messages: Message[];
}
