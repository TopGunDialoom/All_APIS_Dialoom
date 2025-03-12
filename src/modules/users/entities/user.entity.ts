import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Exclude } from 'class-transformer';

/**
 * Roles posibles dentro de Dialoom para un usuario en general:
 * - user (cliente)
 * - host (mentor)
 * - admin (superadministrador)
 */
export enum UserRole {
  USER = 'user',
  HOST = 'host',
  ADMIN = 'admin',
}

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ length: 100 })
  name!: string;

  @Column({ unique: true })
  email!: string;

  /**
   * Contraseña con hash bcrypt
   * Excluimos de la serialización con class-transformer
   */
  @Exclude()
  @Column()
  password!: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.USER,
  })
  role!: UserRole;

  // Podríamos poner isVerified, twoFactorEnabled, etc. si hicimos 2FA
  // @Column({ default: false })
  // isVerified!: boolean;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
