import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Ticket } from './entities/ticket.entity';
import { Message } from './entities/message.entity';
import { SupportService } from './support.service';
import { SupportController } from './support.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Ticket, Message])],
  providers: [SupportService],
  controllers: [SupportController],
  exports: []
})
export class SupportModule {}
