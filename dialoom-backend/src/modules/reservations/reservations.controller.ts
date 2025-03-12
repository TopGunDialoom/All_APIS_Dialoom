import { Controller, Post, Get, Patch, Param, Body, Req, UseGuards } from '@nestjs/common';
import { ReservationsService } from './reservations.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('reservations')
export class ReservationsController {
  constructor(private reservationsService: ReservationsService) {}

  // Crear reserva (ej. user crea)
  @UseGuards(JwtAuthGuard)
  @Post('create')
  async createReservation(@Body() body: any, @Req() req: any) {
    // body.mentorId, body.startTime, body.duration
    const userId = req.user.id; // user => id
    const { mentorId, startTime, duration } = body;
    return this.reservationsService.createReservation(userId, mentorId, new Date(startTime), duration);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id/confirm')
  async confirm(@Param('id') id: string) {
    return this.reservationsService.confirmReservation(Number(id));
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id/cancel')
  async cancel(@Param('id') id: string) {
    return this.reservationsService.cancelReservation(Number(id));
  }

  // Para obtener tokens de la videollamada
  @UseGuards(JwtAuthGuard)
  @Get(':id/call-token')
  async getCallToken(@Param('id') id: string, @Req() req: any) {
    return this.reservationsService.getCallTokens(Number(id), req.user.id);
  }

  // Marcar como completada
  @UseGuards(JwtAuthGuard)
  @Patch(':id/complete')
  async complete(@Param('id') id: string) {
    return this.reservationsService.completeReservation(Number(id));
  }

  // obtener todas (ej. admin / test)
  @UseGuards(JwtAuthGuard)
  @Get()
  async getAll() {
    return this.reservationsService.getAllReservations();
  }
}
