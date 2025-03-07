import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { SupportService } from './support.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';

@Controller('support')
export class SupportController {
  constructor(private supportService: SupportService) {}

  @Post('create')
  @UseGuards(JwtAuthGuard)
  async createTicket(@Req() req: any, @Body() body: { subject: string }) {
    const userId = req.user.id;
    return this.supportService.createTicket(userId, body.subject);
  }

  @Post('message')
  @UseGuards(JwtAuthGuard)
  async postMessage(@Req() req: any, @Body() body: { ticketId: number; content: string }) {
    const senderId = req.user.id;
    return this.supportService.postMessage(body.ticketId, senderId, body.content);
  }
}
