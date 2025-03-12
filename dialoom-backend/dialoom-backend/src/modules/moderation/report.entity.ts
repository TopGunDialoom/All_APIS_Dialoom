import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

/**
 * Representa un reporte de conducta o incidencia
 * Hecho por un usuario "reporter" contra "accused" (otro user),
 * con un status e información adicional.
 */
@Entity('reports')
export class Report {
  @PrimaryGeneratedColumn()
  id: number;

  // quién crea el reporte
  @ManyToOne(() => User)
  @JoinColumn({ name: 'reporter_id' })
  reporter: User;

  // a quién se reporta (accusado), puede ser null si se reporta algo general
  @ManyToOne(() => User, { nullable: true })
  @JoinColumn({ name: 'accused_id' })
  accused: User;

  // razón/categoría (ej. "conducta inapropiada", "no se presentó", etc.)
  @Column({ length: 200, nullable: true })
  reason: string;

  // descripción libre
  @Column({ type: 'text', nullable: true })
  details: string;

  // estado del reporte: pending, in_progress, resolved, dismissed
  @Column({ length: 50, default: 'pending' })
  status: string;

  // posible acción tomada: warning, ban, etc.
  @Column({ length: 100, nullable: true })
  actionTaken: string;

  // comentarios del admin/moderador
  @Column({ type: 'text', nullable: true })
  moderatorNotes: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
