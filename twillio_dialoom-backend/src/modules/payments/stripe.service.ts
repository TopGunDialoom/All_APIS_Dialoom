import { Injectable, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';

@Injectable()
export class StripeService {
  private stripe: Stripe;

  constructor(private config: ConfigService) {
    const key = this.config.get<string>('STRIPE_SECRET_KEY');
    if (!key) {
      throw new Error('Falta STRIPE_SECRET_KEY en .env');
    }
    this.stripe = new Stripe(key, { apiVersion: '2022-11-15' });
  }

  async createPaymentIntent(
    amount: number,
    currency: string,
    hostStripeAccount: string,
    commission: number,
    vat: number
  ) {
    if (!hostStripeAccount) {
      throw new BadRequestException('El host no tiene una cuenta de Stripe');
    }
    const applicationFee = commission + vat;
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
    if (!destination) {
      throw new BadRequestException('No existe destination (hostStripeAccount)');
    }
    return this.stripe.transfers.create({
      amount: Math.round(amount),
      currency,
      destination
    });
  }
}
