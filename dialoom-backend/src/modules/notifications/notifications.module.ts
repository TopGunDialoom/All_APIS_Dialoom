import { Module } from '@nestjs/common';
import { NotificationsService } from './notifications.service';
// No TwilioService import here
// import { TwilioService } from './channels/twilio.service'; // Eliminado

@Module({
  providers: [NotificationsService],
  exports: [NotificationsService],
})
export class NotificationsModule {}
