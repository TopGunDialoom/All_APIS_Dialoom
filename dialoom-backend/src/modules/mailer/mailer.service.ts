import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import nodemailer from 'nodemailer';

@Injectable()
export class MailerService {
  private logger = new Logger(MailerService.name);

  constructor(private config: ConfigService) {}

  async sendMail(to: string, subject: string, text: string) {
    const host = this.config.get<string>('SMTP_HOST') || 'localhost';
    const port = this.config.get<number>('SMTP_PORT') || 25;
    const user = this.config.get<string>('SMTP_USER') || '';
    const pass = this.config.get<string>('SMTP_PASS') || '';

    // crear transporter
    const transporter = nodemailer.createTransport({
      host,
      port,
      secure: false,
      auth: user && pass ? { user, pass } : undefined,
    });

    const info = await transporter.sendMail({
      from: '"Dialoom" <no-reply@dialoom.com>',
      to,
      subject,
      text,
      // html, attachments, etc. future
    });
    this.logger.log(`Email sent to ${to}, messageId=${info.messageId}`);
    return info;
  }
}
