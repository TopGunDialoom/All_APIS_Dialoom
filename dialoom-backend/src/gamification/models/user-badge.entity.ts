import { Entity, PrimaryColumn, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('user_badges')
export class UserBadge {
  @PrimaryColumn({ name: 'user_id' })
  userId: number;

  @PrimaryColumn({ name: 'badge_id' })
  badgeId: number;

  @Column({ name: 'unlocked_at', type: 'timestamp', default: () => 'NOW()' })
  unlockedAt: Date;
}
