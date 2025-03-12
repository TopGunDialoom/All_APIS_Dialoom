import { Controller, Get, Post, Param, Body, UseGuards } from '@nestjs/common';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard'; // asumiendo lo tienes
import { RolesGuard } from '../../common/guards/roles.guard'; // si usas roles
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from '../../modules/users/entities/user.entity'; // si tienes un enum

@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.ADMIN) // asumiendo tienes un rol admin
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Post('ban-user/:id')
  async banUser(@Param('id') userId: string): Promise<void> {
    return this.adminService.banUser(Number(userId));
  }

  @Get('transactions')
  async getAllTransactions() {
    return this.adminService.getAllTransactions();
  }

  @Post('commission')
  async setCommissionRate(@Body() data: { newRate: number }) {
    return this.adminService.setCommissionRate(data.newRate);
  }

  // ... etc. Otros endpoints administrativos
}
