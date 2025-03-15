import { Injectable } from '@nestjs/common';

@Injectable()
export class NotificationsService {
  // Sin Twilio. Por ejemplo, sí tenemos SendGrid o FCM.
  async sendEmail(toEmail: string, subject: string, body: string) {
    // Llamada a @sendgrid/mail u otra
    console.log('[Notifications] Enviando email a', toEmail);
  }

  // Por ejemplo un method de Firebase push
  async sendPush(token: string, payload: any) {
    console.log('[Notifications] (Ficticio) Enviando push a token=', token, 'payload=', payload);
  }
}
