import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Reservation } from './reservation.entity';
import { ReservationsService } from './reservations.service';
import { ReservationsController } from './reservations.controller';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    ConfigModule,
    TypeOrmModule.forFeature([Reservation]),
  ],
  controllers: [ReservationsController],
  providers: [ReservationsService],
  exports: [ReservationsService]
})
export class ReservationsModule {}
