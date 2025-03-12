import { Entity, PrimaryGeneratedColumn, ManyToOne, JoinColumn, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Badge } from './badge.entity';

/**
 * Relación pivot User <-> Badge, con la fecha en que se otorgó la insignia.
 */
@Entity('user_badges')
export class UserBadge {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, user => user.id)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Badge)
  @JoinColumn({ name: 'badge_id' })
  badge: Badge;

  @CreateDateColumn()
  awardedAt: Date;
}
