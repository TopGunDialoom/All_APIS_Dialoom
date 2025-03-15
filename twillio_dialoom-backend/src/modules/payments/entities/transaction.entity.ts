import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum TransactionStatus {
  PENDING = 'pending',
  COMPLETED = 'completed',
  FAILED = 'failed'
}

@Entity()
export class Transaction {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  amount!: number; // en centavos

  @Column()
  currency!: string;

  @Column()
  commissionRate!: number; // 0.10 -> 10%

  @Column()
  vatRate!: number; // 0.21 -> 21%

  @Column()
  feeAmount!: number; // comision + IVA

  @Column()
  hostId!: number;

  @Column({
    type: 'enum',
    enum: TransactionStatus,
    default: TransactionStatus.PENDING
  })
  status!: TransactionStatus;

  @CreateDateColumn()
  createdAt!: Date;

  @ManyToOne(() => User)
  user!: User;
}
