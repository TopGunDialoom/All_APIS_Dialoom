import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { Reservation } from '../reservations/reservation.entity';

// Manejamos transacciones: ref a reserva, cliente, mentor, montos, comision, estado...
@Entity('transactions')
export class Transaction {
  @PrimaryGeneratedColumn()
  id: number;

  // Relación con la reserva
  @ManyToOne(() => Reservation)
  @JoinColumn({ name: 'reservation_id' })
  reservation: Reservation;

  // ID de la transacción en Stripe
  @Column({ nullable: true })
  stripePaymentIntentId: string;

  // posible ID de transfer (Stripe Connect)
  @Column({ nullable: true })
  stripeTransferId: string;

  // Monto bruto en centavos (ej. 5000 => 50.00 USD/EUR)
  @Column({ type: 'int' })
  amount: number;

  // Comision + IVA en centavos
  @Column({ type: 'int', default: 0 })
  platformFee: number;

  @Column({ type: 'int', default: 0 })
  vatFee: number;

  // Moneda (ej 'usd', 'eur')
  @Column({ default: 'eur' })
  currency: string;

  // retencion en dias (ej. 7)
  @Column({ type: 'int', default: 7 })
  retentionDays: number;

  // estado: p. ej. 'PENDING', 'AUTHORIZED', 'RELEASED', 'CANCELLED', 'REFUNDED'
  @Column({ default: 'PENDING' })
  status: string;

  // timestamps
  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
