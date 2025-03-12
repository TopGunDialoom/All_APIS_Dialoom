import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class SmsService {
  private logger = new Logger(SmsService.name);

  constructor() {}

  /**
   * En este placeholder no implementamos Twilio ni ningún provider.
   * Simplemente registramos en logs.
   */
  async sendSms(toNumber: string, text: string): Promise<void> {
    this.logger.warn(`(Placeholder) SMS a ${toNumber}: ${text}`);
    // Más adelante se podrá integrar Twilio, etc.
  }
}
