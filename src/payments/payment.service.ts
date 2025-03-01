import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import Stripe from 'stripe';
import { Payment } from './payment.entity';
import { Reservation } from '../reservations/reservation.entity';
import { User } from '../users/user.entity';
import { CreatePaymentDto } from './dto/create-payment.dto';

@Injectable()
export class PaymentsService {
  private stripe: Stripe;
  constructor(
    @InjectRepository(Payment) private paymentRepo: Repository<Payment>,
    @InjectRepository(Reservation) private resRepo: Repository<Reservation>,
    @InjectRepository(User) private userRepo: Repository<User>
  ) {
    this.stripe = new Stripe(process.env.STRIPE_SECRET || '', { apiVersion: '2022-11-15' });
  }

  async create(userId: number, dto: CreatePaymentDto) {
    // crear PaymentIntent
    const amount = dto.amount;
    const currency = dto.currency || 'usd';
    const intent = await this.stripe.paymentIntents.create({
      amount,
      currency
    });
    let reservation = null;
    if (dto.reservationId) {
      reservation = await this.resRepo.findOne({ where: { id: dto.reservationId, user: { id: userId } } });
    }
    const user = await this.userRepo.findOne({ where: { id: userId } });
    const payment = this.paymentRepo.create({
      amount,
      currency,
      status: intent.status,
      stripeId: intent.id,
      user,
      reservation
    });
    await this.paymentRepo.save(payment);
    return { paymentId: payment.id, clientSecret: intent.client_secret };
  }
}
