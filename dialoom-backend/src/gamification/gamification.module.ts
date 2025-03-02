import { Module } from '@nestjs/common';
import { GamificationService } from './gamification.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Badge } from './models/badge.entity';
import { UserBadge } from './models/user-badge.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Badge, UserBadge])],
  providers: [GamificationService],
  exports: [GamificationService]
})
export class GamificationModule {}
