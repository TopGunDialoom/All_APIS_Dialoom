import { Injectable } from '@nestjs/common';

@Injectable()
export class NotificationsService {
  // Sin Twilio. Ej: usar SendGrid o FCM
  async sendEmail(toEmail: string, subject: string, body: string) {
    console.log('[Notifications] Enviando email a', toEmail);
  }

  async sendPush(token: string, payload: any) {
    console.log('[Notifications] (Ficticio) Enviando push a token=', token);
  }
}
