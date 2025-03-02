import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';

import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/user.module';
import { ReservationsModule } from './reservations/reservation.module';
import { PaymentsModule } from './payments/payment.module';
import { NotificationModule } from './notifications/notification.module';
import { CallsModule } from './calls/calls.module';
import { GamificationModule } from './gamification/gamification.module';
import { AdminModule } from './admin/admin.module';
import { TicketsModule } from './tickets/tickets.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT) || 5432,
      username: process.env.DB_USERNAME,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      autoLoadEntities: true,
      synchronize: false
    }),
    JwtModule.register({ secret: process.env.JWT_SECRET || 'secretKey' }),
    AuthModule,
    UsersModule,
    ReservationsModule,
    PaymentsModule,
    NotificationModule,
    CallsModule,
    GamificationModule,
    AdminModule,
    TicketsModule
  ]
})
export class AppModule {}
