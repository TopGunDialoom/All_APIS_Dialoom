import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Badge } from './models/badge.entity';
import { UserBadge } from './models/user-badge.entity';

@Injectable()
export class GamificationService {
  constructor(
    @InjectRepository(Badge) private badgeRepo: Repository<Badge>,
    @InjectRepository(UserBadge) private userBadgeRepo: Repository<UserBadge>
  ) {}

  async checkAndUnlockBadges(userId: number, newPoints: number) {
    // Lógica que revisa si el usuario desbloquea algún badge
    const allBadges = await this.badgeRepo.find();
    for (const b of allBadges) {
      if (newPoints >= b.pointsRequired) {
        // Chequear si ya tiene
        const exist = await this.userBadgeRepo.findOne({ where: { userId, badgeId: b.id } });
        if (!exist) {
          const ub = this.userBadgeRepo.create({ userId, badgeId: b.id });
          await this.userBadgeRepo.save(ub);
        }
      }
    }
  }
}
