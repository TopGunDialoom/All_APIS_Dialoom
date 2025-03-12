import { Injectable, Logger } from '@nestjs/common';
import { EmailService } from './email/email.service';
import { SmsService } from './sms/sms.service';
import { PushService } from './push/push.service';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    private readonly emailService: EmailService,
    private readonly smsService: SmsService,
    private readonly pushService: PushService,
  ) {}

  /**
   * Ejemplo de notificación de "bienvenida" por correo.
   */
  async sendWelcomeEmail(toEmail: string, userName: string): Promise<void> {
    this.logger.log(`Enviando email de bienvenida a ${toEmail}...`);
    await this.emailService.sendMail({
      to: toEmail,
      subject: '¡Bienvenido a Dialoom!',
      htmlBody: `<p>Hola <b>${userName}</b>, gracias por registrarte en Dialoom.</p>`,
    });
  }

  /**
   * Ejemplo de notificación genérica por SMS (placeholder).
   */
  async sendSmsNotification(toNumber: string, text: string): Promise<void> {
    this.logger.warn(`Enviando SMS (placeholder) a ${toNumber}: ${text}`);
    await this.smsService.sendSms(toNumber, text);
  }

  /**
   * Ejemplo de notificación push (placeholder).
   */
  async sendPushNotification(deviceToken: string, title: string, body: string): Promise<void> {
    this.logger.warn(`Enviando push (placeholder) a ${deviceToken} => ${title}: ${body}`);
    await this.pushService.sendPush(deviceToken, title, body);
  }
}
