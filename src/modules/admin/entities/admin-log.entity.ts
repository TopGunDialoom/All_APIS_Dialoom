import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

/**
 * Ejemplo de log de acciones admin: 'DELETE_USER', 'UPDATE_HOST', etc.
 * Solo demostración de "funcionalidades" de rol admin.
 */
@Entity('admin_logs')
export class AdminLog {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  action!: string;

  @Column({ nullable: true })
  details?: string;

  @CreateDateColumn()
  createdAt!: Date;
}
