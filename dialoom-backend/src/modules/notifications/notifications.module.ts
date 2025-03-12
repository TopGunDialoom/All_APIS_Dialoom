import { Module } from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { EmailService } from './email/email.service';
import { SmsService } from './sms/sms.service';
import { PushService } from './push/push.service';

@Module({
  imports: [],
  providers: [NotificationsService, EmailService, SmsService, PushService],
  exports: [NotificationsService], // para que otros módulos puedan inyectar
})
export class NotificationsModule {}
