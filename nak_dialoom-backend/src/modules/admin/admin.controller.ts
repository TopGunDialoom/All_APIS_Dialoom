import { Controller, Get, Put, Param, Body, UseGuards } from '@nestjs/common';
import { AdminService } from './admin.service';
import { SupportService } from '../support/support.service';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from '../users/entities/user.entity';

@UseGuards(RolesGuard)
@Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
@Controller('admin')
export class AdminController {
  constructor(
    private adminService: AdminService,
    private supportService: SupportService
  ) {}

  @Get('support/tickets')
  async listSupportTickets() {
    return this.supportService.listTickets();
  }

  @Put('users/ban/:id')
  async banUser(@Param('id') userId: string) {
    await this.adminService.banUser(Number(userId));
    return { status: 'banned' };
  }

  @Get('settings/:key')
  async getSetting(@Param('key') key: string) {
    return this.adminService.getSetting(key);
  }

  @Put('settings/:key')
  async updateSetting(@Param('key') key: string, @Body() body: { value: string }) {
    const { value } = body;
    return this.adminService.updateSetting(key, value);
  }
}
