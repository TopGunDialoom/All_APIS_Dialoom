import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { User } from '../users/user.entity';
import { Payment } from '../payments/payment.entity';

@Entity('reservations')
export class Reservation {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  date: Date;

  @Column({ default: false })
  confirmed: boolean;

  @Column({ nullable: true })
  description: string;

  @ManyToOne(() => User, user => user.reservations, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @OneToMany(() => Payment, p => p.reservation)
  payments: Payment[];
}
