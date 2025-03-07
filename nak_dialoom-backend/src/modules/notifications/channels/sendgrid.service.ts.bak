import { Injectable } from '@nestjs/common';
import * as sgMail from '@sendgrid/mail';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class SendGridService {
  constructor(private config: ConfigService) {
    sgMail.setApiKey(this.config.get<string>('SENDGRID_API_KEY') || '');
  }

  async sendEmail(to: string, subject: string, htmlContent: string) {
    const msg = {
      to,
      from: this.config.get<string>('SENDGRID_FROM_EMAIL') || 'no-reply@dialoom.com',
      subject,
      html: htmlContent,
    };
    await sgMail.send(msg);
  }
}
