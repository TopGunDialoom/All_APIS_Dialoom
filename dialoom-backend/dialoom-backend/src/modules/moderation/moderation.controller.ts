import { Controller, Post, Get, Patch, Param, Body, UseGuards, ParseIntPipe } from '@nestjs/common';
import { ModerationService } from './moderation.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
// se asume que tienes un RolesGuard o algo similar
// import { RolesGuard } from '../../common/guards/roles.guard';
// import { Roles } from '../../common/decorators/roles.decorator';
// import { UserRole } from '../users/entities/user.entity';

@Controller('moderation')
export class ModerationController {
  constructor(private readonly moderationService: ModerationService) {}

  /**
   * Crear un reporte. Cualquier usuario logueado podría reportar.
   */
  @UseGuards(JwtAuthGuard)
  @Post('report')
  async createReport(@Body() body: { reporterId: number; accusedId?: number; reason: string; details?: string; }) {
    const { reporterId, accusedId, reason, details } = body;
    return this.moderationService.createReport(reporterId, accusedId, reason, details);
  }

  /**
   * Listar reportes (solo admin)
   */
  @UseGuards(JwtAuthGuard)
  // @UseGuards(RolesGuard)
  // @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  @Get('reports')
  async findAllReports() {
    return this.moderationService.findAllReports();
  }

  /**
   * Ver un reporte puntual (solo admin)
   */
  @UseGuards(JwtAuthGuard)
  // @UseGuards(RolesGuard)
  // @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  @Get('report/:id')
  async getOne(@Param('id', ParseIntPipe) id: number) {
    return this.moderationService.findOneReport(id);
  }

  /**
   * Actualizar un reporte, ej. status o acción. (solo admin)
   */
  @UseGuards(JwtAuthGuard)
  // @UseGuards(RolesGuard)
  // @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  @Patch('report/:id')
  async updateReport(@Param('id', ParseIntPipe) id: number, @Body() updates: any) {
    return this.moderationService.updateReport(id, updates);
  }

  /**
   * Banear a un usuario (solo admin). Ejemplo.
   */
  @UseGuards(JwtAuthGuard)
  // @UseGuards(RolesGuard)
  // @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  @Post('ban-user')
  async banUser(@Body() body: { userId: number; reason?: string }) {
    return this.moderationService.banUser(body.userId, body.reason || 'No reason');
  }
}
