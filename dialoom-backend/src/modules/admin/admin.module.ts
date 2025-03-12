import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
// Suponiendo que tu "UsersModule", "PaymentsModule", etc. ya existen
import { UsersModule } from '../users/users.module';
import { PaymentsModule } from '../payments/payments.module';
import { ReservationsModule } from '../reservations/reservations.module'; // si existe
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
// import { ReservationEntity } from '../reservations/entities/reservation.entity'; // si lo deseas
// import { SomeAdminEntity } from './entities/some-admin.entity';

@Module({
  imports: [
    forwardRef(() => UsersModule),
    forwardRef(() => PaymentsModule),
    // forwardRef(() => ReservationsModule), // si lo tienes creado
    // TypeOrmModule.forFeature([SomeAdminEntity]),
  ],
  controllers: [AdminController],
  providers: [AdminService],
  exports: [AdminService],
})
export class AdminModule {}
