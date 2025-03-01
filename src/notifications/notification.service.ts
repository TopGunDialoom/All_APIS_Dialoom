import { Injectable } from '@nestjs/common';
import { NotificationGateway } from './notification.gateway';
import * as admin from 'firebase-admin';
import * as path from 'path';
import { Reservation } from '../reservations/reservation.entity';

@Injectable()
export class NotificationService {
  constructor(private gateway: NotificationGateway) {
    // Inicializar Firebase si el archivo existe
    const serviceAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT_PATH;
    if (serviceAccountPath) {
      try {
        const resolvedPath = path.isAbsolute(serviceAccountPath)
          ? serviceAccountPath
          : path.resolve(serviceAccountPath);
        const serviceAccount = require(resolvedPath);
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccount)
        });
      } catch (e) {
        console.error('Firebase admin initialization error:', e.message);
      }
    }
  }

  async notifyReservationCreated(reservation: Reservation) {
    // WebSocket broadcast
    this.gateway.server.emit('reservationCreated', { reservationId: reservation.id });
    // Enviar push si el user tiene deviceToken
    if (reservation.user && reservation.user.deviceToken) {
      await this.sendPush(reservation.user.deviceToken, 'Reservation', 'Your reservation has been created!');
    }
  }

  async sendPush(token: string, title: string, body: string) {
    if (!admin.apps.length) return;
    if (!token) return;
    try {
      await admin.messaging().send({
        token,
        notification: { title, body }
      });
    } catch (err) {
      console.error('Push error:', err);
    }
  }
}
