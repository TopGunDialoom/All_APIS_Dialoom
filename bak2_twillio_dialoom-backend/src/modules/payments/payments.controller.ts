import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';

@Controller('payments')
export class PaymentsController {
  constructor(private paymentsService: PaymentsService) {}

  @Post('charge')
  @UseGuards(JwtAuthGuard)
  async chargeHost(@Req() req: any, @Body() body: { hostId: number; amount: number }) {
    const clientId = req.user.id;
    const { hostId, amount } = body;
    return this.paymentsService.createCharge(clientId, hostId, amount);
  }
}
