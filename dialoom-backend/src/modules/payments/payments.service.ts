import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThanOrEqual } from 'typeorm';
import { Transaction } from './transaction.entity';
import { Reservation } from '../reservations/reservation.entity';
import { Stripe } from 'stripe';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class PaymentsService {
  private stripe: Stripe;

  constructor(
    @InjectRepository(Transaction) private txRepo: Repository<Transaction>,
    @InjectRepository(Reservation) private resRepo: Repository<Reservation>,
    private configService: ConfigService
  ) {
    const secretKey = this.configService.get<string>('STRIPE_SECRET_KEY');
    if (!secretKey) {
      throw new Error('Stripe secret key not found in config');
    }
    this.stripe = new Stripe(secretKey, { apiVersion: '2022-11-15' });
  }

  /**
   * createTransaction
   * Lógica para crear la transacción (PaymentIntent en Stripe).
   * amount en centavos, currency en 'eur' o 'usd', etc.
   */
  async createTransaction(reservationId: number, userId: number, amount: number, currency: string = 'eur'): Promise<Transaction> {
    // Verificar que la reserva exista
    const reservation = await this.resRepo.findOne({ where: { id: reservationId }, relations: ['user', 'mentor'] });
    if (!reservation) {
      throw new NotFoundException('Reservation not found');
    }
    // Calcular comision y vat
    // Ej. 10% + IVA 21%
    // comision base => 0.10 * amount
    const baseFee = Math.floor(amount * 0.10);
    const vatFee = Math.floor(baseFee * 0.21);

    // Crear PaymentIntent en Stripe
    // Modo "manual" para retener (capture later) o "automatic"
    const paymentIntent = await this.stripe.paymentIntents.create({
      amount,
      currency,
      payment_method_types: ['card'],
      capture_method: 'manual',
      // En algunos casos se usa 'automatic', pero 'manual' permite controlar retención
      metadata: {
        reservationId: String(reservationId),
        userId: String(userId),
      },
    });

    const tx = this.txRepo.create({
      reservation: { id: reservationId } as Reservation,
      stripePaymentIntentId: paymentIntent.id,
      amount,
      platformFee: baseFee,
      vatFee,
      currency,
      retentionDays: 7, // config default
      status: 'PENDING'
    });
    return await this.txRepo.save(tx);
  }

  /**
   * confirmPayment
   * Se llama cuando Stripe confirma el pago (webhook) o manual. Se finaliza la transacción: "AUTHORIZED"
   */
  async confirmPayment(txId: number): Promise<Transaction> {
    const tx = await this.txRepo.findOne({ where: { id: txId }});
    if (!tx) throw new NotFoundException('Transaction not found');
    if (tx.status !== 'PENDING') {
      throw new BadRequestException(`Transaction status not PENDING. Current: ${tx.status}`);
    }
    // capturar el PaymentIntent en Stripe (o confirmarlo).
    // O solo confirm. Depende de la lógica.
    // Ej: call paymentIntents.confirm if no confirm yet
    try {
      await this.stripe.paymentIntents.confirm(tx.stripePaymentIntentId);
    } catch (err) {
      throw new BadRequestException(`Error confirming PaymentIntent: ${err.message}`);
    }
    // Actualizamos status a 'AUTHORIZED'
    tx.status = 'AUTHORIZED';
    return this.txRepo.save(tx);
  }

  /**
   * captureFunds
   * Se llama para capturar efectivamente el cargo.
   * (Si se usó capture_method=manual)
   */
  async captureFunds(txId: number): Promise<Transaction> {
    const tx = await this.txRepo.findOne({ where: { id: txId }});
    if (!tx) throw new NotFoundException('Transaction not found');
    if (tx.status !== 'AUTHORIZED') {
      throw new BadRequestException(`Transaction status not AUTHORIZED. Current: ${tx.status}`);
    }
    // Capturar
    try {
      await this.stripe.paymentIntents.capture(tx.stripePaymentIntentId);
    } catch (err) {
      throw new BadRequestException(`Error capturing PaymentIntent: ${err.message}`);
    }
    tx.status = 'CAPTURED';
    return this.txRepo.save(tx);
  }

  /**
   * handleRefund
   * para reembolsar total o parcial
   */
  async handleRefund(txId: number, amountToRefund?: number): Promise<Transaction> {
    const tx = await this.txRepo.findOne({ where: { id: txId }});
    if (!tx) throw new NotFoundException('Transaction not found');
    if (tx.status !== 'CAPTURED' && tx.status !== 'AUTHORIZED') {
      throw new BadRequestException('Transaction is not refundable in current status');
    }
    try {
      // Monto en centavos
      let amt = amountToRefund;
      if (!amt) {
        amt = tx.amount; // reembolso total
      }
      await this.stripe.refunds.create({
        payment_intent: tx.stripePaymentIntentId,
        amount: amt
      });
    } catch (err) {
      throw new BadRequestException(`Error refunding PaymentIntent: ${err.message}`);
    }
    tx.status = 'REFUNDED';
    return this.txRepo.save(tx);
  }

  /**
   * releaseFundsToHost
   * Lógica para Stripe Connect: transfiere la parte neta (amount - fees) al host si ya pasó la retención.
   * Retención = retentionDays
   */
  async releaseFundsToHost(txId: number): Promise<Transaction> {
    const tx = await this.txRepo.findOne({ where: { id: txId }, relations: ['reservation']});
    if (!tx) throw new NotFoundException('Transaction not found');

    if (tx.status !== 'CAPTURED') {
      throw new BadRequestException('Funds must be captured first');
    }
    // Ver si ya pasaron los retentionDays
    const createdPlusRetention = new Date(tx.createdAt.getTime() + tx.retentionDays*24*60*60*1000);
    const now = new Date();
    if (now < createdPlusRetention) {
      throw new BadRequestException('Retention period not ended yet');
    }

    // Lógica: net = tx.amount - tx.platformFee - tx.vatFee
    const netAmount = tx.amount - tx.platformFee - tx.vatFee;
    if (netAmount <= 0) {
      throw new BadRequestException('No net amount to transfer');
    }
    // TODO: se asume mentor tiene 'stripeAccountId', no se ejemplifica.
    // Transfer con stripe
    try {
      const transfer = await this.stripe.transfers.create({
        amount: netAmount,
        currency: tx.currency,
        destination: 'acct_XXX_HOST_STRIPE', // en la vida real => mentor.stripeAccountId
        transfer_group: `tx_${tx.id}`
      });
      tx.stripeTransferId = transfer.id;
      tx.status = 'RELEASED';
    } catch (err) {
      throw new BadRequestException(`Error releasing funds: ${err.message}`);
    }

    return this.txRepo.save(tx);
  }

  /**
   * CRON job idea: autoReleaseDueTransactions
   * Revisa transacciones con retencionDays completados => releaseFundsToHost
   */
  async autoReleaseDueTransactions(): Promise<void> {
    const now = new Date();
    // Buscamos tx con status=CAPTURED y createdAt + retention <= now
    // Ej:
    const all = await this.txRepo.find({ where: { status: 'CAPTURED' } });
    for (const t of all) {
      const releaseDate = new Date(t.createdAt.getTime() + t.retentionDays*24*60*60*1000);
      if (releaseDate <= now) {
        // release
        try {
          await this.releaseFundsToHost(t.id);
        } catch (e) {
          // log error, continue
          console.error(`Failed to release txId=${t.id}:`, e.message);
        }
      }
    }
  }
}
