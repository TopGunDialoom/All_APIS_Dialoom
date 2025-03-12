export enum TransactionStatus {
  PENDING = 'pending',
  PAID = 'paid',
  FAILED = 'failed'
}

export class Transaction {
  id!: number;
  amount!: number;
  status!: TransactionStatus;
}
