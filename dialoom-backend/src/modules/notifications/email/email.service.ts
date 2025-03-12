import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as nodemailer from 'nodemailer';

export interface EmailPayload {
  to: string;
  subject: string;
  htmlBody: string;
}

@Injectable()
export class EmailService {
  private transporter: nodemailer.Transporter;
  private logger = new Logger(EmailService.name);

  constructor(private configService: ConfigService) {
    // SMTP config (Plesk local)
    // Ejemplo: host=localhost, port=25, no auth si Plesk lo autoriza
    // O si necesitamos user/pass, se setea en .env
    const host = this.configService.get<string>('SMTP_HOST', 'localhost');
    const port = +this.configService.get<number>('SMTP_PORT', 25);
    const user = this.configService.get<string>('SMTP_USER', '');
    const pass = this.configService.get<string>('SMTP_PASS', '');

    this.logger.log(`Creando transporter SMTP en ${host}:${port} con usuario=${user}`);

    const transporterOptions: nodemailer.TransportOptions = {
      host,
      port,
      secure: false, // normalmente 25, no SSL
    };

    if (user && pass) {
      (transporterOptions as any).auth = { user, pass };
    }

    this.transporter = nodemailer.createTransport(transporterOptions);
  }

  async sendMail(payload: EmailPayload): Promise<void> {
    try {
      const mailOptions: nodemailer.SendMailOptions = {
        from: this.configService.get<string>('SMTP_FROM', 'dialoom-noreply@yourdomain.com'),
        to: payload.to,
        subject: payload.subject,
        html: payload.htmlBody,
      };

      await this.transporter.sendMail(mailOptions);
      this.logger.log(`Email enviado correctamente a ${payload.to}`);
    } catch (error) {
      this.logger.error(`Error enviando correo a ${payload.to}`, error);
      throw error;
    }
  }
}
