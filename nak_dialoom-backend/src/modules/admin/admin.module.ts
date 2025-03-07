import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminService } from './admin.service';
import { AdminController } from './admin.controller';
import { Setting } from './entities/setting.entity';
import { Log } from './entities/log.entity';
import { UsersModule } from '../users/users.module';
import { PaymentsModule } from '../payments/payments.module';
import { GamificationModule } from '../gamification/gamification.module';
import { SupportModule } from '../support/support.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Setting, Log]),
    UsersModule,
    PaymentsModule,
    GamificationModule,
    SupportModule
  ],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
