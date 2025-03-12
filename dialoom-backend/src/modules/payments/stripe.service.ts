import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';

/**
 * StripeService:
 *  - Versión simple para cobros básicos. 
 *  - A futuro: retenciones, payouts, etc. (en la parte 6).
 */
@Injectable()
export class StripeService {
  private stripeClient: Stripe;

  constructor(private config: ConfigService) {
    const secretKey = this.config.get<string>('STRIPE_SECRET_KEY') || 'sk_test_XXX';
    this.stripeClient = new Stripe(secretKey, {
      apiVersion: '2022-11-15',
    });
  }

  async createCharge(amount: number, currency = 'USD', sourceToken: string, description = 'Dialoom charge') {
    // Mínimo ejemplo
    return this.stripeClient.charges.create({
      amount,
      currency,
      source: sourceToken,
      description,
    });
  }
}
