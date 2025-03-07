import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { Ticket } from './ticket.entity';
import { User } from '../../users/entities/user.entity';

@Entity()
export class Message {
  @PrimaryGeneratedColumn()
  id!: number;

  @ManyToOne(() => Ticket, { nullable: false })
  ticket!: Ticket;

  @ManyToOne(() => User, { nullable: false })
  sender!: User;

  @Column()
  content!: string;

  @CreateDateColumn()
  timestamp!: Date;
}
