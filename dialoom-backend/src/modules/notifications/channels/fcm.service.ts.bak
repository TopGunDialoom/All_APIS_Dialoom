import { Injectable } from '@nestjs/common';
import * as admin from 'firebase-admin';

@Injectable()
export class FcmService {
  constructor() {
    // Se asume que en el AppModule se inicializó firebase-admin
  }

  async sendPushNotification(deviceToken: string, title: string, body: string, data?: any) {
    const message: admin.messaging.Message = {
      token: deviceToken,
      notification: { title, body },
      data: data || {},
      android: { priority: 'high' }
    };
    return admin.messaging().send(message);
  }
}
