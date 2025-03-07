import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { Ticket } from './ticket.entity';
import { User } from '../../users/entities/user.entity';

@Entity()
export class Message {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Ticket, ticket => ticket.messages, { onDelete: 'CASCADE' })
  ticket: Ticket;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  sender: User;

  @Column()
  content: string;

  @CreateDateColumn()
  timestamp: Date;
}
