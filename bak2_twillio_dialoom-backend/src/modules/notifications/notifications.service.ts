import { Injectable } from '@nestjs/common';
import { TwilioService } from './channels/twilio.service';

@Injectable()
export class NotificationsService {
  constructor(private twilioService: TwilioService) {}

  async sendWhatsapp(toNumber: string, message: string) {
    // Solo 2 params
    return this.twilioService.sendWhatsappMessage(toNumber, message);
  }
}
