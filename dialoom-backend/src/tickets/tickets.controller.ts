import { Controller, Post, Get, Patch, Body, Param, UseGuards, Request } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { TicketsService } from './tickets.service';

@Controller('tickets')
@UseGuards(AuthGuard('jwt'))
export class TicketsController {
  constructor(private ticketsService: TicketsService) {}

  @Post()
  async createTicket(@Request() req, @Body() body: { subject: string, message: string }) {
    return this.ticketsService.create(req.user.userId, body.subject, body.message);
  }

  @Get()
  async getTickets(@Request() req) {
    return this.ticketsService.listForUser(req.user.userId);
  }

  @Patch(':id')
  async updateTicket(@Param('id') id: number, @Body() body: { status: string }) {
    return this.ticketsService.updateStatus(+id, body.status);
  }
}
