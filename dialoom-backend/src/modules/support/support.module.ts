import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SupportService } from './support.service';
import { SupportController } from './support.controller';
import { Ticket } from './entities/ticket.entity';
import { Message } from './entities/message.entity';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([Ticket, Message]), UsersModule],
  providers: [SupportService],
  controllers: [SupportController],
  exports: [SupportService]
})
export class SupportModule {}
