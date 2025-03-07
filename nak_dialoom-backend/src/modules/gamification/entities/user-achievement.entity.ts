import { Entity, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Achievement } from './achievement.entity';

@Entity()
export class UserAchievement {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, user => user.id, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Achievement, { onDelete: 'CASCADE' })
  achievement: Achievement;

  @CreateDateColumn()
  achievedAt: Date;
}
