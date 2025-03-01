import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ReservationsService } from './reservation.service';
import { CreateReservationDto } from './dto/create-reservation.dto';

@Controller('reservations')
export class ReservationsController {
  constructor(private reservationsService: ReservationsService) {}

  @UseGuards(AuthGuard('jwt'))
  @Get()
  async getMyReservations(@Request() req) {
    return this.reservationsService.findForUser(req.user.userId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async createRes(@Request() req, @Body() dto: CreateReservationDto) {
    return this.reservationsService.create(req.user.userId, dto);
  }
}
