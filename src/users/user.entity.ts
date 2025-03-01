import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Reservation } from '../reservations/reservation.entity';
import { Payment } from '../payments/payment.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column({ default: '' })
  name: string;

  @Column({ default: 0 })
  points: number;

  @Column({ name: 'device_token', nullable: true })
  deviceToken: string;

  @Column({ default: 'user' })
  role: string;

  @OneToMany(() => Reservation, r => r.user)
  reservations: Reservation[];

  @OneToMany(() => Payment, p => p.user)
  payments: Payment[];
}
