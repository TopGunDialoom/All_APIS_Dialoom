import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { StripeService } from './stripe.service';

@Module({
  imports: [],
  providers: [StripeService, ConfigService],
  exports: [StripeService],
})
export class PaymentsModule {}
