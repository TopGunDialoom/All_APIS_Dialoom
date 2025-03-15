import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { Setting } from './entities/setting.entity';
import { Log } from './entities/log.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Setting, Log])
  ],
  controllers: [AdminController],
  providers: [AdminService],
  exports: []
})
export class AdminModule {}
