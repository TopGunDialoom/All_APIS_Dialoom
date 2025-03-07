import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThanOrEqual } from 'typeorm';
import { StripeService } from './stripe.service';
import { Transaction, TransactionStatus } from './entities/transaction.entity';
import { UsersService } from '../users/users.service';
import { User } from '../users/entities/user.entity';
import * as dayjs from 'dayjs';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class PaymentsService {
  private retentionDays: number;
  private defaultCommission: number;
  private defaultVAT: number;

  constructor(
    private stripeService: StripeService,
    private usersService: UsersService,
    @InjectRepository(Transaction) private txRepo: Repository<Transaction>,
    private config: ConfigService
  ) {
    this.retentionDays = this.config.get<number>('PAYMENT_RETENTION_DAYS') || 7;
    this.defaultCommission = this.config.get<number>('DEFAULT_COMMISSION_RATE') || 0.10;
    this.defaultVAT = this.config.get<number>('DEFAULT_VAT_RATE') || 0.21;
  }

  async createCharge(clientId: number, hostId: number, amount: number, currency: string = 'EUR') {
    const host: User = await this.usersService.findById(hostId);
    if (!host) {
      throw new BadRequestException('Host no disponible');
    }
    // Calcular comision + IVA
    const commission = amount * this.defaultCommission;
    const vat = commission * this.defaultVAT;
    const totalFee = commission + vat;

    // Crear PaymentIntent en Stripe
    const paymentIntent = await this.stripeService.createPaymentIntent(
      amount, currency, host.stripeAccountId, Math.round(commission), Math.round(vat)
    );

    const now = new Date();
    const availableOn = dayjs(now).add(this.retentionDays, 'day').toDate();

    const tx = this.txRepo.create({
      amount,
      currency,
      commissionRate: this.defaultCommission,
      vatRate: this.defaultVAT,
      feeAmount: totalFee,
      hostId: hostId,
      status: TransactionStatus.HOLD,
      user: { id: clientId } as User
    });
    await this.txRepo.save(tx);

    return { paymentIntentClientSecret: paymentIntent.client_secret };
  }

  async processPayouts(): Promise<void> {
    const now = new Date();
    const dueTxs = await this.txRepo.find({
      where: {
        status: TransactionStatus.HOLD,
        createdAt: LessThanOrEqual(dayjs(now).subtract(this.retentionDays, 'day').toDate())
      }
    });
    for (const tx of dueTxs) {
      // Transferir la parte neta al host
      tx.status = TransactionStatus.PAID_OUT;
      await this.txRepo.save(tx);
      // TODO: Llamar a stripeService.createTransfer(...) si no se hizo automatic
    }
  }
}
