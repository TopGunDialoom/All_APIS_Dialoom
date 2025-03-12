import { Controller, Post, Body, Param, Patch, Get, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  // EJEMPLO: crear una transaccion
  @UseGuards(JwtAuthGuard)
  @Post('create')
  async createTx(@Body() dto: { reservationId: number; amount: number; currency?: string; }) {
    return this.paymentsService.createTransaction(dto.reservationId, 0, dto.amount, dto.currency || 'eur');
    // Nota: userId=0 => ajusta a tu gusto, ej. parse del token
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':txId/confirm')
  async confirm(@Param('txId') txId: string) {
    return this.paymentsService.confirmPayment(Number(txId));
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':txId/capture')
  async capture(@Param('txId') txId: string) {
    return this.paymentsService.captureFunds(Number(txId));
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':txId/refund')
  async refund(@Param('txId') txId: string, @Body() body: { amount?: number }) {
    return this.paymentsService.handleRefund(Number(txId), body.amount);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':txId/release')
  async release(@Param('txId') txId: string) {
    return this.paymentsService.releaseFundsToHost(Number(txId));
  }

  // Endpoints extra p.ej: get tx detail, etc.
}
