import { Injectable } from '@nestjs/common';

@Injectable()
export class SupportService {
  handleTicket(ticketId: number) {
    return 'ticket handled: ' + ticketId;
  }
}
