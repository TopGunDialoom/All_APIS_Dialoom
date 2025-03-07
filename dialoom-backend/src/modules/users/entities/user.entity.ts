import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn
} from 'typeorm';

export enum UserRole {
  USER = 'user',
  HOST = 'host',
  ADMIN = 'admin',
  SUPERADMIN = 'superadmin',
}

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id!: number;  // con ! para indicar a TS que lo maneja TypeORM

  @Column({ length: 100 })
  name!: string;

  @Column({ unique: true, length: 150 })
  email!: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.USER
  })
  role!: UserRole;

  @Column({ default: false })
  isVerified!: boolean;  // verificación de identidad completada?

  @Column({ default: false })
  twoFactorEnabled!: boolean;

  @Column({ nullable: true })
  twoFactorSecret!: string; // Campo opcional

  @Column({ nullable: true })
  stripeAccountId?: string; // También opcional

  // Gamificación
  @Column({ default: 0 })
  points!: number;

  @Column({ default: 1 })
  level!: number;

  @CreateDateColumn()
  createdAt!: Date;
}