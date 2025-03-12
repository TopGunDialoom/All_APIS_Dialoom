import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class PushService {
  private logger = new Logger(PushService.name);

  constructor() {}

  /**
   * Placeholder para notificaciones push.
   * En el futuro, integraciones con FCM u otros.
   */
  async sendPush(deviceToken: string, title: string, body: string): Promise<void> {
    this.logger.warn(`(Placeholder) PUSH => ${deviceToken}: ${title} - ${body}`);
    // En la futura integración, usaremos la SDK de FCM o APNs, etc.
  }
}
