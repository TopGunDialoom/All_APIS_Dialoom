import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from '../users/entities/user.entity';
// Si tienes un "Host" distinto a "User", import that entity.
// O si host es un user con role=host, ajusta la relación a "mentor: User" con role=host

@Entity('reservations')
export class Reservation {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'user_id' })
  user: User; // cliente

  @ManyToOne(() => User)
  @JoinColumn({ name: 'mentor_id' })
  mentor: User; // si lo manejas con user role=host

  @Column({ type: 'datetime' })
  startTime: Date;

  @Column({ type: 'int', default: 60 })
  durationMinutes: number;

  @Column({ default: '' })
  agoraChannel: string; // Nombre/canal de Agora

  @Column({ default: '' })
  status: string; // p.ej. 'PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED'

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
