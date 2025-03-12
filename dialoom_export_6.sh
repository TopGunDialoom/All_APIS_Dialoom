#!/usr/bin/env bash
# ==============================================================================
# dialoom_export_6.sh
# Script de exportación para el APARTADO 6: "Pagos y Retención de Comisiones"
# ==============================================================================
# Este script genera/actualiza:
#   - src/modules/payments/ con:
#       * transaction.entity.ts
#       * payments.service.ts
#       * payments.controller.ts
#       * payments.module.ts
#   - Ajuste en app.module.ts para importar PaymentsModule (opcional).
# ==============================================================================
set -e

BASE_DIR="dialoom-backend"
SRC_DIR="${BASE_DIR}/src"
PAYMENTS_DIR="${SRC_DIR}/modules/payments"

echo "[INFO] Comenzando script de exportación (apartado 6: pagos y retención de comisiones)..."

# Verificar que la carpeta base exista
if [ ! -d "$BASE_DIR" ]; then
  echo "[ERROR] La carpeta '$BASE_DIR' no existe. Asegúrate de haber ejecutado scripts anteriores."
  exit 1
fi

cd "$BASE_DIR"

# Crear el subdirectorio payments si no existe
echo "[INFO] Creando carpeta '$PAYMENTS_DIR'..."
mkdir -p "$PAYMENTS_DIR"

########################################
# 1. ENTIDAD: transaction.entity.ts
########################################
cat <<'EOF' > "$PAYMENTS_DIR/transaction.entity.ts"
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { Reservation } from '../reservations/reservation.entity';

// Manejamos transacciones: ref a reserva, cliente, mentor, montos, comision, estado...
@Entity('transactions')
export class Transaction {
  @PrimaryGeneratedColumn()
  id: number;

  // Relación con la reserva
  @ManyToOne(() => Reservation)
  @JoinColumn({ name: 'reservation_id' })
  reservation: Reservation;

  // ID de la transacción en Stripe
  @Column({ nullable: true })
  stripePaymentIntentId: string;

  // posible ID de transfer (Stripe Connect)
  @Column({ nullable: true })
  stripeTransferId: string;

  // Monto bruto en centavos (ej. 5000 => 50.00 USD/EUR)
  @Column({ type: 'int' })
  amount: number;

  // Comision + IVA en centavos
  @Column({ type: 'int', default: 0 })
  platformFee: number;

  @Column({ type: 'int', default: 0 })
  vatFee: number;

  // Moneda (ej 'usd', 'eur')
  @Column({ default: 'eur' })
  currency: string;

  // retencion en dias (ej. 7)
  @Column({ type: 'int', default: 7 })
  retentionDays: number;

  // estado: p. ej. 'PENDING', 'AUTHORIZED', 'RELEASED', 'CANCELLED', 'REFUNDED'
  @Column({ default: 'PENDING' })
  status: string;

  // timestamps
  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

echo "[INFO] Creado transaction.entity.ts"

########################################
# 2. SERVICE: payments.service.ts
########################################
cat <<'EOF' > "$PAYMENTS_DIR/payments.service.ts"
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
EOF

echo "[INFO] Creado payments.service.ts"

########################################
# 3. CONTROLLER: payments.controller.ts
########################################
cat <<'EOF' > "$PAYMENTS_DIR/payments.controller.ts"
import { Controller, Post, Body, Param, Patch, Get, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  // EJEMPLO: crear una transaccion
  @UseGuards(JwtAuthGuard)
  @Post('create')
  async createTx(@Body() dto: { reservationId: number; amount: number; currency?: string; }) {
    return this.paymentsService.createTransaction(dto.reservationId, 0, dto.amount, dto.currency || 'eur');
    // Nota: userId=0 => ajusta a tu gusto, ej. parse del token
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':txId/confirm')
  async confirm(@Param('txId') txId: string) {
    return this.paymentsService.confirmPayment(Number(txId));
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':txId/capture')
  async capture(@Param('txId') txId: string) {
    return this.paymentsService.captureFunds(Number(txId));
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':txId/refund')
  async refund(@Param('txId') txId: string, @Body() body: { amount?: number }) {
    return this.paymentsService.handleRefund(Number(txId), body.amount);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':txId/release')
  async release(@Param('txId') txId: string) {
    return this.paymentsService.releaseFundsToHost(Number(txId));
  }

  // Endpoints extra p.ej: get tx detail, etc.
}
EOF

echo "[INFO] Creado payments.controller.ts"

########################################
# 4. MODULE: payments.module.ts
########################################
cat <<'EOF' > "$PAYMENTS_DIR/payments.module.ts"
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PaymentsService } from './payments.service';
import { PaymentsController } from './payments.controller';
import { Transaction } from './transaction.entity';
import { Reservation } from '../reservations/reservation.entity';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    ConfigModule,
    TypeOrmModule.forFeature([Transaction, Reservation]),
  ],
  controllers: [PaymentsController],
  providers: [PaymentsService],
  exports: [PaymentsService],
})
export class PaymentsModule {}
EOF

echo "[INFO] Creado payments.module.ts"

########################################
# 5. Insertar en app.module.ts
########################################
APP_MODULE_PATH="${SRC_DIR}/app.module.ts"
if [ -f "$APP_MODULE_PATH" ]; then
  if grep -q "PaymentsModule" "$APP_MODULE_PATH"; then
    echo "[INFO] app.module.ts ya contiene 'PaymentsModule'. No se modifica."
  else
    echo "[INFO] Insertando PaymentsModule en app.module.ts..."
    sed -i.bak "s%@Module({%@Module({\
  imports: [ PaymentsModule ],%g" "$APP_MODULE_PATH"
    # También insert import { PaymentsModule }
    if ! grep -q "import { PaymentsModule" "$APP_MODULE_PATH"; then
      sed -i.bak "1i import { PaymentsModule } from './modules/payments/payments.module';" "$APP_MODULE_PATH"
    fi
  fi
else
  echo "[WARN] No se encontró app.module.ts. Agrega manualmente: 'PaymentsModule' en imports."
fi

########################################
# FIN
########################################
echo "[DONE] Script completado para APARTADO 6 (Pagos y Retención)."
echo "Revisa '${PAYMENTS_DIR}' para ver transaction.entity.ts, payments.service.ts, etc."
echo "Si sed no funcionó como esperas en app.module.ts, edita manualmente."
