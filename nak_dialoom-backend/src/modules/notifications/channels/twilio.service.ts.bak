import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import twilio from 'twilio';

@Injectable()
export class TwilioService {
  private client: twilio.Twilio;

  constructor(private config: ConfigService) {
    const accountSid = config.get<string>('TWILIO_ACCOUNT_SID');
    const authToken = config.get<string>('TWILIO_AUTH_TOKEN');
    this.client = twilio(accountSid, authToken);
  }

  async sendSms(toNumber: string, message: string) {
    const fromNumber = this.config.get<string>('TWILIO_SMS_FROM');
    return this.client.messages.create({
      body: message,
      from: fromNumber,
      to: toNumber
    });
  }

  async sendWhatsappMessage(toNumber: string, message: string) {
    const fromWhatsapp = this.config.get<string>('TWILIO_WHATSAPP_FROM');
    return this.client.messages.create({
      body: message,
      from: fromWhatsapp,
      to: \`whatsapp:\${toNumber}\`
    });
  }
}
