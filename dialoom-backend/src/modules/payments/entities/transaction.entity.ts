import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum TransactionStatus {
  HOLD = 'hold',
  RELEASED = 'released',
  PAID_OUT = 'paid_out',
  REFUNDED = 'refunded'
}

@Entity()
export class Transaction {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  amount: number;  // importe total en centavos

  @Column({ default: 'EUR' })
  currency: string;

  @Column({ type: 'float' })
  commissionRate: number;  // ej 0.10 para 10%

  @Column({ type: 'float' })
  vatRate: number;  // ej 0.21 para 21%

  @Column({ default: 0 })
  feeAmount: number; // comision + IVA

  @Column()
  hostId: number;   // ID del host que recibirá la parte neta

  @Column({ type: 'enum', enum: TransactionStatus, default: TransactionStatus.HOLD })
  status: TransactionStatus;

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  user: User;   // usuario que pagó
}
