import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, OneToMany, ManyToOne } from 'typeorm';
import { Message } from './message.entity';
import { User } from '../../users/entities/user.entity';

export enum TicketStatus {
  OPEN = 'open',
  CLOSED = 'closed'
}

@Entity()
export class Ticket {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  subject!: string;

  @Column({
    type: 'enum',
    enum: TicketStatus,
    default: TicketStatus.OPEN
  })
  status!: TicketStatus;

  @ManyToOne(() => User, { nullable: false })
  user!: User;

  @CreateDateColumn()
  createdAt!: Date;

  @OneToMany(() => Message, (msg) => msg.ticket, { cascade: true })
  messages!: Message[];
}
