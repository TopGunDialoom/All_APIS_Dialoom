import { Module } from '@nestjs/common';
import { TwilioService } from './channels/twilio.service';
import { NotificationsService } from './notifications.service';

@Module({
  providers: [TwilioService, NotificationsService],
  exports: [NotificationsService]
})
export class NotificationsModule {}
