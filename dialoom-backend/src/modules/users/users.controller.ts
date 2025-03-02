import { Controller, Get, Put, Body, Req, UseGuards, Patch } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from './entities/user.entity';

@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get('me')
  async getProfile(@Req() req: any) {
    const userId = req.user.id;
    return this.usersService.findById(userId);
  }

  @Put('me')
  async updateProfile(@Req() req: any, @Body() updateDto: any) {
    const userId = req.user.id;
    return this.usersService.updateProfile(userId, updateDto);
  }

  // Solo un admin o superadmin puede verificar a un usuario
  @Patch(':id/verify')
  @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  async verifyUser(@Req() req: any) {
    const userId = parseInt(req.params.id, 10);
    await this.usersService.verifyUser(userId);
    return { message: 'Usuario verificado' };
  }
}
