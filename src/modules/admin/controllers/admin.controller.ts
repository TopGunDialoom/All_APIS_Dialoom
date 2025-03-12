import { Controller, Post, Body, Param, ParseIntPipe, Get, UseGuards } from '@nestjs/common';
import { AdminService } from '../services/admin.service';
import { JwtAuthGuard } from '../../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../../common/guards/roles.guard';
import { Roles } from '../../../common/decorators/roles.decorator';

@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin') // Cualquier endpoint en este controller => rol admin
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Post('ban-user/:id')
  banUser(@Param('id', ParseIntPipe) userId: number, @Body('reason') reason: string) {
    return this.adminService.banUser(userId, reason);
  }

  @Post('promote-host/:id')
  promoteToHost(@Param('id', ParseIntPipe) userId: number) {
    return this.adminService.promoteToHost(userId);
  }

  @Post('promote-admin/:id')
  promoteToAdmin(@Param('id', ParseIntPipe) userId: number) {
    return this.adminService.promoteToAdmin(userId);
  }

  @Get('logs')
  getLogs() {
    return this.adminService.getLogs();
  }
}
