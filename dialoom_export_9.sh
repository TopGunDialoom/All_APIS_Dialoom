#!/usr/bin/env bash
# ===========================================================================
# dialoom_export_notif9.sh
# Exporta el apartado 9: "Notificaciones y Comunicaciones" - Dialoom
# Modo "placeholder" para push y SMS; SMTP básico para correo con Plesk
# ===========================================================================
set -e

echo "[INFO] Comenzando script de exportación (Apartado 9: Notificaciones)."

# 1) Verificar si existe carpeta dialoom-backend. Si no, la creamos.
if [ -d "dialoom-backend" ]; then
  echo "[INFO] La carpeta 'dialoom-backend' ya existe."
else
  echo "[INFO] Creando carpeta 'dialoom-backend'..."
  mkdir dialoom-backend
fi

# Ingresar a la carpeta
cd dialoom-backend

# ----------------------------------------------------------------------------
# 2) Creamos/actualizamos un subdirectorio para el módulo Notifications
# ----------------------------------------------------------------------------
echo "[INFO] Creando subcarpetas para notifications..."
mkdir -p src/modules/notifications
mkdir -p src/modules/notifications/entities
mkdir -p src/modules/notifications/email
mkdir -p src/modules/notifications/push
mkdir -p src/modules/notifications/sms

# ----------------------------------------------------------------------------
# 3) Generar/actualizar un notifications.module.ts
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/notifications/notifications.module.ts
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
EOF

# ----------------------------------------------------------------------------
# 4) notifications.service.ts
#    Servicio principal de notificaciones. Internamente llama a email/push/sms
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/notifications/notifications.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { EmailService } from './email/email.service';
import { SmsService } from './sms/sms.service';
import { PushService } from './push/push.service';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    private readonly emailService: EmailService,
    private readonly smsService: SmsService,
    private readonly pushService: PushService,
  ) {}

  /**
   * Ejemplo de notificación de "bienvenida" por correo.
   */
  async sendWelcomeEmail(toEmail: string, userName: string): Promise<void> {
    this.logger.log(`Enviando email de bienvenida a ${toEmail}...`);
    await this.emailService.sendMail({
      to: toEmail,
      subject: '¡Bienvenido a Dialoom!',
      htmlBody: `<p>Hola <b>${userName}</b>, gracias por registrarte en Dialoom.</p>`,
    });
  }

  /**
   * Ejemplo de notificación genérica por SMS (placeholder).
   */
  async sendSmsNotification(toNumber: string, text: string): Promise<void> {
    this.logger.warn(`Enviando SMS (placeholder) a ${toNumber}: ${text}`);
    await this.smsService.sendSms(toNumber, text);
  }

  /**
   * Ejemplo de notificación push (placeholder).
   */
  async sendPushNotification(deviceToken: string, title: string, body: string): Promise<void> {
    this.logger.warn(`Enviando push (placeholder) a ${deviceToken} => ${title}: ${body}`);
    await this.pushService.sendPush(deviceToken, title, body);
  }
}
EOF

# ----------------------------------------------------------------------------
# 5) EmailService con SMTP (Plesk) - se asume que .env tendrá SMTP vars
#    No usaremos nodemailer-ses ni nodemailer-sendgrid; sólo SMTP local.
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/notifications/email/email.service.ts
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
EOF

# ----------------------------------------------------------------------------
# 6) sms.service.ts => placeholder
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/notifications/sms/sms.service.ts
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
EOF

# ----------------------------------------------------------------------------
# 7) push.service.ts => placeholder
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/notifications/push/push.service.ts
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
EOF

# ----------------------------------------------------------------------------
# 8) Ajuste en app.module.ts para NotificationsModule (si no existe ya).
#    Lo agregamos a mano con un sed naive que, tras "imports: [...", inyecte la línea
# ----------------------------------------------------------------------------
if [ -f "src/app.module.ts" ]; then
  # Revisar si ya está importado
  if grep -q "NotificationsModule" src/app.module.ts; then
    echo "[INFO] 'NotificationsModule' ya parece importado en app.module.ts, no modifico."
  else
    echo "[INFO] Insertando import para 'NotificationsModule' en app.module.ts..."

    sed -i.bak "/^import.*{.*AuthModule.*}.*/a import { NotificationsModule } from './modules/notifications/notifications.module';" src/app.module.ts || true

    # Insertar en imports
    sed -i.bak "s/\(imports: *\[[^]]*\)/\1,\n    NotificationsModule/" src/app.module.ts || true
  fi
else
  echo "[WARN] src/app.module.ts no existe, no puedo inyectar NotificationsModule automáticamente."
fi

# ----------------------------------------------------------------------------
# 9) Actualizar .env si no existe, agregamos SMTP vars
# ----------------------------------------------------------------------------
if [ -f ".env" ]; then
  echo "[INFO] .env ya existe, agregando variables SMTP (si no existen)."
  if ! grep -q "SMTP_HOST=" .env; then
    echo "SMTP_HOST=localhost" >> .env
  fi
  if ! grep -q "SMTP_PORT=" .env; then
    echo "SMTP_PORT=25" >> .env
  fi
  if ! grep -q "SMTP_USER=" .env; then
    echo "SMTP_USER=" >> .env
  fi
  if ! grep -q "SMTP_PASS=" .env; then
    echo "SMTP_PASS=" >> .env
  fi
  if ! grep -q "SMTP_FROM=" .env; then
    echo "SMTP_FROM=dialoom-noreply@domain.com" >> .env
  fi
else
  echo "[INFO] Creando .env con las vars SMTP por defecto."
  cat <<EOT > .env
# Ejemplo .env para Notificaciones (SMTP en Plesk)
SMTP_HOST=localhost
SMTP_PORT=25
SMTP_USER=
SMTP_PASS=
SMTP_FROM=dialoom-noreply@domain.com
EOT
fi

echo "[DONE] Script finalizado para apartado 9 (Notificaciones)."
echo "Revisa la carpeta src/modules/notifications/* para ver los archivos creados."
