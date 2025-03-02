import { Module } from '@nestjs/common';
import { AdminController } from './admin.controller';
import { UsersModule } from '../users/user.module';
import { ReservationsModule } from '../reservations/reservation.module';
import { PaymentsModule } from '../payments/payment.module';

@Module({
  imports: [UsersModule, ReservationsModule, PaymentsModule],
  controllers: [AdminController]
})
export class AdminModule {}
