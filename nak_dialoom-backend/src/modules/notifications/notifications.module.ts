import { Module } from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { FcmService } from './channels/fcm.service';
import { SendGridService } from './channels/sendgrid.service';
import { TwilioService } from './channels/twilio.service';

@Module({
  imports: [],
  providers: [NotificationsService, FcmService, SendGridService, TwilioService],
  exports: [NotificationsService]
})
export class NotificationsModule {}
