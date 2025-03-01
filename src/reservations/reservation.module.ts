import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ReservationsService } from './reservation.service';
import { ReservationsController } from './reservation.controller';
import { Reservation } from './reservation.entity';
import { User } from '../users/user.entity';
import { NotificationModule } from '../notifications/notification.module';

@Module({
  imports: [TypeOrmModule.forFeature([Reservation, User]), NotificationModule],
  providers: [ReservationsService],
  controllers: [ReservationsController]
})
export class ReservationsModule {}
