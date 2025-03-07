import { Injectable } from '@nestjs/common';
import { FcmService } from './channels/fcm.service';
import { SendGridService } from './channels/sendgrid.service';
import { TwilioService } from './channels/twilio.service';

@Injectable()
export class NotificationsService {
  constructor(
    private fcmService: FcmService,
    private sendGridService: SendGridService,
    private twilioService: TwilioService
  ) {}

  async sendPush(token: string, title: string, body: string, data?: any) {
    return this.fcmService.sendPushNotification(token, title, body, data);
  }

  async sendEmail(to: string, subject: string, htmlContent: string) {
    return this.sendGridService.sendEmail(to, subject, htmlContent);
  }

  async sendSMS(toNumber: string, message: string) {
    return this.twilioService.sendSms(toNumber, message);
  }

  async sendWhatsApp(toNumber: string, message: string) {
    return this.twilioService.sendWhatsappMessage(toNumber, message);
  }
}
