import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { StripeService } from './stripe.service';
import { Transaction, TransactionStatus } from './entities/transaction.entity';
import { UsersService } from '../users/users.service';
import { User } from '../users/entities/user.entity';
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

  async createCharge(clientId: number, hostId: number, amount: number, currency = 'EUR') {
    const host = await this.usersService.findById(hostId);
    if (!host) {
      throw new NotFoundException('Host no encontrado');
    }
    if (!host.stripeAccountId) {
      throw new BadRequestException('El host no tiene stripeAccountId');
    }

    const commission = amount * this.defaultCommission;
    const vat = commission * this.defaultVAT;
    const paymentIntent = await this.stripeService.createPaymentIntent(
      amount,
      currency,
      host.stripeAccountId,
      commission,
      vat
    );

    const tx = this.txRepo.create({
      amount,
      currency,
      commissionRate: this.defaultCommission,
      vatRate: this.defaultVAT,
      feeAmount: commission + vat,
      hostId: hostId,
      status: TransactionStatus.PENDING,
      user: { id: clientId } as User
    });
    return this.txRepo.save(tx);
  }
}
