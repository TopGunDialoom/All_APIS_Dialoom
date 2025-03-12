#!/usr/bin/env bash
set -e

################################################################################
# export_no_twilio.sh
# Genera los archivos/carpetas de tu backend Dialoom (versión SIN Twilio).
# Se incluyen los módulos Auth, Users, Payments, Gamification, Support, Admin, etc.
# Basta con ejecutarlo en una carpeta vacía y luego "npm install" + "npm run build".
################################################################################

echo "Creando estructura de carpetas..."
mkdir -p "."
mkdir -p "locales"
mkdir -p "test"
mkdir -p "Firebase"
mkdir -p "src"
mkdir -p "src/types"
mkdir -p "src/config"
mkdir -p "src/auth"
mkdir -p "src/auth/guards"
mkdir -p "src/common"
mkdir -p "src/common/interceptors"
mkdir -p "src/common/decorators"
mkdir -p "src/common/guards"
mkdir -p "src/modules"
mkdir -p "src/modules/payments"
mkdir -p "src/modules/payments/entities"
mkdir -p "src/modules/auth"
mkdir -p "src/modules/auth/strategies"
mkdir -p "src/modules/auth/guards"
mkdir -p "src/modules/gamification"
mkdir -p "src/modules/gamification/entities"
mkdir -p "src/modules/admin"
mkdir -p "src/modules/admin/entities"
mkdir -p "src/modules/support"
mkdir -p "src/modules/support/entities"
mkdir -p "src/modules/users"
mkdir -p "src/modules/users/entities"
mkdir -p "src/modules/notifications"
mkdir -p "src/modules/notifications/entities"

################################################################################
# 1. package.json
################################################################################

cat << '__EOC__' > "package.json"
{
  "name": "dialoom-backend",
  "version": "1.0.0",
  "description": "Backend NestJS for Dialoom platform (without Twilio)",
  "scripts": {
    "start": "nest start",
    "start:dev": "nest start --watch",
    "build": "nest build",
    "start:prod": "node dist/main.js",
    "test": "jest --coverage"
  },
  "dependencies": {
    "@nestjs/common": "^9.0.0",
    "@nestjs/core": "^9.0.0",
    "@nestjs/jwt": "^9.0.0",
    "@nestjs/passport": "^9.0.0",
    "@nestjs/platform-express": "^9.0.0",
    "@nestjs/typeorm": "^9.0.0",
    "@sendgrid/mail": "^7.7.0",
    "@nestjs/config": "^2.2.0",
    "agora-access-token": "^2.0.0",
    "bcrypt": "^5.1.0",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.1",
    "firebase-admin": "^11.0.0",
    "helmet": "^6.0.0",
    "ioredis": "^5.2.0",
    "passport": "^0.6.0",
    "passport-apple": "^2.0.2",
    "passport-facebook": "^3.0.0",
    "passport-google-oauth20": "^2.0.0",
    "passport-jwt": "^4.0.0",
    "passport-microsoft": "^1.0.0",
    "redis": "^4.0.11",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.0.0",
    "stripe": "^11.0.0",
    "typeorm": "^0.3.12"
  },
  "devDependencies": {
    "@nestjs/cli": "^9.0.0",
    "@nestjs/schematics": "^9.0.0",
    "@types/bcrypt": "^5.0.0",
    "@types/express": "^4.17.13",
    "@types/jest": "^28.1.1",
    "@types/node": "^18.0.0",
    "@types/passport-facebook": "^3.0.0",
    "@types/passport-google-oauth20": "^2.0.16",
    "@types/passport-jwt": "^3.0.6",
    "@types/passport-microsoft": "^1.0.0",
    "@types/redis": "^4.0.11",
    "@types/socket.io": "^3.0.2",
    "@types/stripe": "^8.0.0",
    "@typescript-eslint/eslint-plugin": "^5.0.0",
    "@typescript-eslint/parser": "^5.0.0",
    "eslint": "^8.0.0",
    "jest": "^28.1.1",
    "ts-jest": "^28.0.8",
    "ts-loader": "^9.2.6",
    "typescript": "^4.6.4",
    "@types/passport-apple": "^2.0.2"
  },
  "jest": {
    "moduleFileExtensions": [
      "js",
      "json",
      "ts"
    ],
    "rootDir": "src",
    "testRegex": ".*\\.spec\\.ts$",
    "transform": {
      "^.+\\.(t|j)s$": "ts-jest"
    },
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  }
}
__EOC__

################################################################################
# 2. tsconfig.json
################################################################################

cat << '__EOC__' > "tsconfig.json"
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "ES2021",
    "lib": ["ES2021", "DOM"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "strictPropertyInitialization": false,
    "esModuleInterop": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "test"]
}
__EOC__


################################################################################
# 3. .env.example
################################################################################

cat << '__EOC__' > ".env.example"
# Ejemplo de variables de entorno para Dialoom (SIN Twilio)

# PostgreSQL
POSTGRES_DB=dialoomdb
POSTGRES_USER=dialoom
POSTGRES_PASSWORD=password
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# JWT
JWT_SECRET=tu_jwt_secret

# OAuth credentials (Google, Apple, etc.)
GOOGLE_CLIENT_ID=xxx.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=xxx
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback

FACEBOOK_APP_ID=xxx
FACEBOOK_APP_SECRET=xxx
MICROSOFT_CLIENT_ID=xxx
MICROSOFT_CLIENT_SECRET=xxx
APPLE_CLIENT_ID=xxx
APPLE_TEAM_ID=xxx
APPLE_KEY_ID=xxx
APPLE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nxxxxx\n-----END PRIVATE KEY-----"

# Stripe
STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxx

# Firebase
FIREBASE_PROJECT_ID=tu_project_id
FIREBASE_CLIENT_EMAIL=tu_firebase_email
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nxxxx\n-----END PRIVATE KEY-----"

# Commission & VAT
DEFAULT_COMMISSION_RATE=0.10
DEFAULT_VAT_RATE=0.21

# Retention settings (días)
PAYMENT_RETENTION_DAYS=7
__EOC__

################################################################################
# 4. Dockerfile
################################################################################

cat << '__EOC__' > "Dockerfile"
# Dockerfile para Dialoom (versión sin Twilio)

# Etapa 1: build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Etapa 2: runtime
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "dist/main.js"]
__EOC__

################################################################################
# 5. docker-compose.yml
################################################################################

cat << '__EOC__' > "docker-compose.yml"
version: '3.8'
services:
  api:
    build: .
    image: dialoom-backend:latest
    container_name: dialoom-api
    env_file: .env
    ports:
      - "3000:3000"
    depends_on:
      - db
      - redis
    restart: unless-stopped
  
  db:
    image: postgres:15-alpine
    container_name: dialoom-db
    environment:
      - POSTGRES_DB=\${POSTGRES_DB}
      - POSTGRES_USER=\${POSTGRES_USER}
      - POSTGRES_PASSWORD=\${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    container_name: dialoom-redis
    restart: unless-stopped

volumes:
  postgres_data:
__EOC__

################################################################################
# 6. README.md
################################################################################

cat << '__EOC__' > "README.md"
# Dialoom Backend (Sin Twilio)

Este repositorio contiene el **backend** de la plataforma **Dialoom**, en versión que **no incluye Twilio** para SMS/WhatsApp.
Si luego deseas integrar Twilio, reactivas la lógica y dependencias.

## Características
- NestJS 9
- Stripe (pagos)
- Agora (videollamadas)
- Firebase (notifs push)
- SendGrid (emails transaccionales)
- etc.

## Pasos
1. Crea tu \`.env\` o usa \`.env.example\`.
2. \`npm install\`
3. \`npm run build\`
4. \`npm start\`
__EOC__

################################################################################
# 7. locales/en.yaml, test/app.e2e-spec.ts ...
################################################################################

cat << '__EOC__' > "locales/en.yaml"
errors:
  unexpected_error: "An unexpected error occurred. Please try again later."
__EOC__

cat << '__EOC__' > "test/app.e2e-spec.ts"
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  it('/health (GET)', () => {
    return request(app.getHttpServer())
      .get('/health')
      .expect(200)
      .expect('OK');
  });

  afterAll(async () => {
    await app.close();
  });
});
__EOC__

################################################################################
# 8. Firebase/* (opcionales)
################################################################################

cat << '__EOC__' > "Firebase/google-services.json"
{
  "project_info": {
    "project_number": "279884688149",
    "project_id": "dialoom-c912e"
  },
  "client": []
}
__EOC__

cat << '__EOC__' > "Firebase/GoogleService-Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict><key>TEST</key><string>Dialoom Firebase iOS here</string></dict>
</plist>
__EOC__

################################################################################
# 9. src/main.ts, app.service.ts, app.controller.ts
################################################################################

cat << '__EOC__' > "src/main.ts"
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import helmet from 'helmet';
import { json, urlencoded } from 'express';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.use(helmet());
  app.use(json({ limit: '10mb' }));
  app.use(urlencoded({ extended: true, limit: '10mb' }));
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));
  app.enableCors({ origin: '*' });

  await app.listen(3000);
  console.log('Dialoom backend (sin Twilio) running on port 3000');
}
bootstrap();
__EOC__

cat << '__EOC__' > "src/app.service.ts"
import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello Dialoom!';
  }
}
__EOC__

cat << '__EOC__' > "src/app.controller.ts"
import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/health')
  healthCheck(): string {
    return 'OK';
  }
}
__EOC__

################################################################################
# 10. src/app.module.ts
################################################################################

cat << '__EOC__' > "src/app.module.ts"
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';

import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { GamificationModule } from './modules/gamification/gamification.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { SupportModule } from './modules/support/support.module';
import { AdminModule } from './modules/admin/admin.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        host: config.get<string>('POSTGRES_HOST', 'localhost'),
        port: +config.get<number>('POSTGRES_PORT', 5432),
        username: config.get<string>('POSTGRES_USER'),
        password: config.get<string>('POSTGRES_PASSWORD'),
        database: config.get<string>('POSTGRES_DB'),
        entities: [__dirname + '/modules/**/*.entity.{js,ts}'],
        synchronize: false,
      }),
      inject: [ConfigService],
    }),
    AuthModule,
    UsersModule,
    PaymentsModule,
    GamificationModule,
    NotificationsModule,
    SupportModule,
    AdminModule
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
__EOC__

################################################################################
# 11. notifications.module.ts / notifications.service.ts (sin Twilio)
################################################################################

cat << '__EOC__' > "src/modules/notifications/notifications.module.ts"
import { Module } from '@nestjs/common';
import { NotificationsService } from './notifications.service';

@Module({
  providers: [NotificationsService],
  exports: [NotificationsService],
})
export class NotificationsModule {}
__EOC__

cat << '__EOC__' > "src/modules/notifications/notifications.service.ts"
import { Injectable } from '@nestjs/common';

@Injectable()
export class NotificationsService {
  // Sin Twilio. Ej: usar SendGrid o FCM
  async sendEmail(toEmail: string, subject: string, body: string) {
    console.log('[Notifications] Enviando email a', toEmail);
  }

  async sendPush(token: string, payload: any) {
    console.log('[Notifications] (Ficticio) Enviando push a token=', token);
  }
}
__EOC__

################################################################################
# 12. admin.module.ts / admin.service.ts
################################################################################

cat << '__EOC__' > "src/modules/admin/admin.module.ts"
import { Module } from '@nestjs/common';
import { AdminService } from './admin.service';

@Module({
  providers: [AdminService],
  exports: [AdminService],
})
export class AdminModule {}
__EOC__

cat << '__EOC__' > "src/modules/admin/admin.service.ts"
import { Injectable } from '@nestjs/common';

@Injectable()
export class AdminService {
  getAdminStuff() {
    return 'admin data';
  }
}
__EOC__

################################################################################
# 13. auth.module.ts / auth.service.ts
################################################################################

cat << '__EOC__' > "src/modules/auth/auth.module.ts"
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';

@Module({
  providers: [AuthService],
  exports: [AuthService],
})
export class AuthModule {}
__EOC__

cat << '__EOC__' > "src/modules/auth/auth.service.ts"
import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
  login() {
    return 'auth login...';
  }
}
__EOC__

################################################################################
# 14. users.module.ts / users.service.ts / user.entity.ts (mínimo)
################################################################################

cat << '__EOC__' > "src/modules/users/users.module.ts"
import { Module } from '@nestjs/common';
import { UsersService } from './users.service';

@Module({
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
__EOC__

cat << '__EOC__' > "src/modules/users/users.service.ts"
import { Injectable } from '@nestjs/common';

@Injectable()
export class UsersService {
  async findById(id: number) {
    // Ejemplo: retorna un user simulado
    if (id === 1) {
      return { id:1, name: 'John', email: 'john@dialoom.com' };
    }
    return null; // o undefined
  }
}
__EOC__

cat << '__EOC__' > "src/modules/users/entities/user.entity.ts"
export enum UserRole {
  USER = 'user',
  HOST = 'host',
  ADMIN = 'admin',
  SUPERADMIN = 'superadmin'
}

export class User {
  id!: number;
  name!: string;
  email!: string;
  role!: UserRole;
}
__EOC__

################################################################################
# 15. payments.module.ts / payments.service.ts / transaction.entity.ts
################################################################################

cat << '__EOC__' > "src/modules/payments/payments.module.ts"
import { Module } from '@nestjs/common';
import { PaymentsService } from './payments.service';

@Module({
  providers: [PaymentsService],
  exports: [PaymentsService],
})
export class PaymentsModule {}
__EOC__

cat << '__EOC__' > "src/modules/payments/payments.service.ts"
import { Injectable } from '@nestjs/common';

@Injectable()
export class PaymentsService {
  createCharge(clientId: number, hostId: number, amount: number) {
    return { msg: 'Charge created', clientId, hostId, amount };
  }
}
__EOC__

cat << '__EOC__' > "src/modules/payments/entities/transaction.entity.ts"
export enum TransactionStatus {
  PENDING = 'pending',
  PAID = 'paid',
  FAILED = 'failed'
}

export class Transaction {
  id!: number;
  amount!: number;
  status!: TransactionStatus;
}
__EOC__

################################################################################
# 16. gamification.module.ts / gamification.service.ts / achievement.entity.ts
################################################################################

cat << '__EOC__' > "src/modules/gamification/gamification.module.ts"
import { Module } from '@nestjs/common';
import { GamificationService } from './gamification.service';

@Module({
  providers: [GamificationService],
  exports: [GamificationService],
})
export class GamificationModule {}
__EOC__

cat << '__EOC__' > "src/modules/gamification/gamification.service.ts"
import { Injectable } from '@nestjs/common';

@Injectable()
export class GamificationService {
  getAchievements() {
    return ['Achievement1','Achievement2'];
  }
}
__EOC__

cat << '__EOC__' > "src/modules/gamification/entities/achievement.entity.ts"
export class Achievement {
  id!: number;
  name!: string;
  points!: number;
}
__EOC__

################################################################################
# 17. support.module.ts / support.service.ts
################################################################################

cat << '__EOC__' > "src/modules/support/support.module.ts"
import { Module } from '@nestjs/common';
import { SupportService } from './support.service';

@Module({
  providers: [SupportService],
  exports: [SupportService],
})
export class SupportModule {}
__EOC__

cat << '__EOC__' > "src/modules/support/support.service.ts"
import { Injectable } from '@nestjs/common';

@Injectable()
export class SupportService {
  handleTicket(ticketId: number) {
    return 'ticket handled: ' + ticketId;
  }
}
__EOC__

################################################################################
# 18. Fin
################################################################################

echo "=================================="
echo "Export sin Twilio completado (con UsersModule, PaymentsModule, etc)."
echo "Ahora: npm install && npm run build && npm run start"
echo "=================================="
