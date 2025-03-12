import { Injectable } from '@nestjs/common';

@Injectable()
export class PaymentsService {
  createCharge(clientId: number, hostId: number, amount: number) {
    return { msg: 'Charge created', clientId, hostId, amount };
  }
}
