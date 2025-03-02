import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';

@Injectable()
export class StripeService {
  private stripe: Stripe;
  constructor(private config: ConfigService) {
    this.stripe = new Stripe(this.config.get<string>('STRIPE_SECRET_KEY'), {
      apiVersion: '2022-11-15'
    });
  }

  async createPaymentIntent(amount: number, currency: string, hostStripeAccount: string, commission: number, vat: number) {
    const applicationFee = commission + vat; // en centavos si se requiere
    return this.stripe.paymentIntents.create({
      amount: Math.round(amount),
      currency,
      payment_method_types: ['card'],
      transfer_data: {
        destination: hostStripeAccount,
      },
      application_fee_amount: Math.round(applicationFee)
    });
  }

  async createTransfer(amount: number, currency: string, destination: string) {
    return this.stripe.transfers.create({
      amount: Math.round(amount),
      currency,
      destination
    });
  }
}
