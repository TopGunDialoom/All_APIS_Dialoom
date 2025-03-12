import { Controller, Get, Post, Body, Param, ParseIntPipe, Patch, UseGuards } from '@nestjs/common';
import { GamificationService } from './gamification.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('gamification')
export class GamificationController {
  constructor(private readonly gamificationService: GamificationService) {}

  // CRUD de badges
  @UseGuards(JwtAuthGuard)
  @Get('badges')
  findAll() {
    return this.gamificationService.findAllBadges();
  }

  // Crear/actualizar badge
  @UseGuards(JwtAuthGuard)
  @Patch('badge/:id')
  updateBadge(@Param('id', ParseIntPipe) id: number, @Body() dto: any) {
    return this.gamificationService.createOrUpdateBadge(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Post('badge/create')
  createBadge(@Body() dto: any) {
    return this.gamificationService.createOrUpdateBadge(null, dto);
  }

  // Award badge
  @UseGuards(JwtAuthGuard)
  @Post('award')
  async awardBadge(
    @Body() body: { userId: number; badgeId: number },
  ) {
    return this.gamificationService.awardBadgeToUser(body.userId, body.badgeId);
  }
}
