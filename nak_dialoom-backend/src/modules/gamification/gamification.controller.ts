import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { GamificationService } from './gamification.service';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from '../users/entities/user.entity';

@Controller('gamification')
@UseGuards(RolesGuard)
export class GamificationController {
  constructor(private gamificationService: GamificationService) {}

  @Post('achievements')
  @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  async createAchievement(@Body() body: { name: string, description: string, points?: number }) {
    const { name, description, points } = body;
    return this.gamificationService.createAchievement(name, description, points || 0);
  }

  @Post('levels')
  @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  async createLevel(@Body() body: { levelNumber: number, requiredPoints: number }) {
    const { levelNumber, requiredPoints } = body;
    return this.gamificationService.createLevel(levelNumber, requiredPoints);
  }
}
