import { Controller, Post, Body, UseGuards, Request } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { PaymentsService } from './payment.service';
import { CreatePaymentDto } from './dto/create-payment.dto';

@Controller('payments')
export class PaymentsController {
  constructor(private paymentsService: PaymentsService) {}

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async createPayment(@Request() req, @Body() dto: CreatePaymentDto) {
    const userId = req.user.userId;
    return this.paymentsService.create(userId, dto);
  }
}
