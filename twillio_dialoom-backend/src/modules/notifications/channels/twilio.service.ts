import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Twilio from 'twilio';

@Injectable()
export class TwilioService {
  private client: Twilio.Twilio;

  constructor(private configService: ConfigService) {
    const accountSid = this.configService.get<string>('TWILIO_ACCOUNT_SID') || '';
    const authToken = this.configService.get<string>('TWILIO_AUTH_TOKEN') || '';
    this.client = Twilio(accountSid, authToken);
  }

  async sendWhatsappMessage(toNumber: string, message: string) {
    const fromWhatsapp = this.configService.get<string>('TWILIO_WHATSAPP_FROM') || 'whatsapp:+14155238886';
    return this.client.messages.create({
      body: message,
      from: fromWhatsapp,
      to: `whatsapp:${toNumber}`,
    });
  }
}
