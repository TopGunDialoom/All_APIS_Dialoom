import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminLog } from './entities/admin-log.entity';
import { AdminService } from './services/admin.service';
import { AdminController } from './controllers/admin.controller';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([AdminLog]), UsersModule],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
