import { Controller, Get, Param, Patch, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { UsersService } from '../users/user.service';
import { ReservationsService } from '../reservations/reservation.service';
import { PaymentsService } from '../payments/payment.service';

@Controller('admin')
@UseGuards(AuthGuard('jwt'))
export class AdminController {
  constructor(
    private usersService: UsersService,
    private reservationsService: ReservationsService,
    private paymentsService: PaymentsService
  ) {}

  @Get('users')
  async listUsers() {
    return this.usersService.getAllUsers();
  }

  @Patch('users/:id/role')
  async changeUserRole(@Param('id') id: number, @Query('role') role: string) {
    // Cambiar rol
    return this.usersService.update(+id, { role });
  }

  // Otras funciones de superadmin ...
}
