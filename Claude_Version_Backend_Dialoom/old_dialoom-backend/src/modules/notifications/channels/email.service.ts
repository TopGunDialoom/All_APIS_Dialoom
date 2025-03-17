import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as SendGrid from '@sendgrid/mail';

@Injectable()
export class EmailService {
  constructor(private configService: ConfigService) {
    SendGrid.setApiKey(this.configService.get<string>('SENDGRID_API_KEY'));
  }

  async sendEmail(
    to: string,
    subject: string,
    html: string,
    text?: string,
    from?: string,
  ): Promise<void> {
    const defaultFrom = this.configService.get<string>('SENDGRID_FROM_EMAIL');
    
    const msg = {
      to,
      from: from || defaultFrom,
      subject,
      text: text || '',
      html,
    };
    
    try {
      await SendGrid.send(msg);
    } catch (error) {
      console.error('Error sending email:', error);
      if (error.response) {
        console.error(error.response.body);
      }
      throw error;
    }
  }
}
