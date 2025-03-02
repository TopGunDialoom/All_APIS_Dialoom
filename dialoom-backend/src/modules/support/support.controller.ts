import { Controller, Post, Get, Patch, Param, Body, Req, UseGuards } from '@nestjs/common';
import { SupportService } from './support.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('support')
@UseGuards(JwtAuthGuard)
export class SupportController {
  constructor(private supportService: SupportService) {}

  @Post('tickets')
  async createTicket(@Req() req: any, @Body() body: { subject: string }) {
    const userId = req.user.id;
    return this.supportService.createTicket(userId, body.subject);
  }

  @Get('tickets/:id/messages')
  async getTicketMessages(@Param('id') ticketId: string) {
    return this.supportService.getMessages(Number(ticketId));
  }

  @Patch('tickets/:id/close')
  async closeTicket(@Param('id') ticketId: string) {
    await this.supportService.closeTicket(Number(ticketId));
    return { status: 'closed' };
  }

  @Get('tickets')
  async listAllTickets() {
    return this.supportService.listTickets();
  }
}
