import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('tickets')
export class Ticket {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'user_id' })
  userId: number;

  @Column()
  subject: string;

  @Column({ nullable: true })
  message: string;

  @Column({ default: 'open' })
  status: string;

  @Column({ name: 'created_at', type: 'timestamp', default: () => 'NOW()' })
  createdAt: Date;
}
