#!/usr/bin/env bash
# ==========================================================================
# dialoom_export_part1.sh
#
# Genera la base del Backend Dialoom (Part 1):
#  - Apartado 2: Arquitectura del Backend (NestJS + MySQL + basic Stripe).
#  - Apartado 3: Autenticación y Seguridad (JWT, local user/pass).
#
# Omitimos: Oauth, Apple/Google login, Twilio, Firebase, SendGrid... (futuro).
# Incluimos placeholders para facilitar su futura integración.
#
# Escenarios:
# DB: MySQL (MariaDB 10.6.18) en localhost:3306
# user=ubuntu, pass=paczug-beGkov-0syvci, db=coreadmin
#
# Variables env: AGORA_APP_ID, AGORA_APP_CERT, STRIPE_SECRET_KEY, etc.
#
# 1) Crea carpeta dialoom-backend
# 2) Genera archivos de NestJS base (AppModule, AuthModule, UsersModule, etc.)
# 3) Estructura para Payment con Stripe minimal, sin retención avanzada.
# 4) Deja placeholder MailService (usando SMTP Plesk).
#
# ==========================================================================

mkdir -p dialoom-backend
cd dialoom-backend || exit 1

echo "==> Creando estructura de carpetas..."

# Directorios
mkdir -p src
mkdir -p src/config
mkdir -p src/common
mkdir -p src/modules
mkdir -p src/modules/auth
mkdir -p src/modules/users
mkdir -p src/modules/users/entities
mkdir -p src/modules/payments
mkdir -p src/modules/payments/entities
mkdir -p src/modules/mailer
mkdir -p dist

# .gitignore
cat <<EOF > .gitignore
node_modules
dist
.env
EOF

# package.json (versión base, incluye MySQL, Stripe, JWT)
cat <<EOF > package.json
{
  "name": "dialoom-backend",
  "version": "1.0.0",
  "description": "Dialoom Backend - Part 1 (Architecture + Auth). MySQL, Stripe, JWT, no Twilio/Firebase yet.",
  "scripts": {
    "start": "nest start",
    "start:dev": "nest start --watch",
    "build": "nest build",
    "start:prod": "node dist/main.js",
    "test": "jest --coverage"
  },
  "dependencies": {
    "@nestjs/common": "^9.0.0",
    "@nestjs/config": "^2.2.0",
    "@nestjs/core": "^9.0.0",
    "@nestjs/jwt": "^9.0.0",
    "@nestjs/passport": "^9.0.0",
    "@nestjs/platform-express": "^9.0.0",
    "@nestjs/typeorm": "^9.0.0",
    "agora-access-token": "^2.0.0",
    "bcrypt": "^5.1.0",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.0",
    "helmet": "^6.0.0",
    "ioredis": "^5.2.0",
    "mysql2": "^3.2.0",
    "nodemailer": "^6.9.3",
    "passport": "^0.6.0",
    "passport-jwt": "^4.0.0",
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
    "@types/passport-jwt": "^3.0.6",
    "@types/redis": "^4.0.11",
    "@types/stripe": "^8.0.0",
    "@typescript-eslint/eslint-plugin": "^5.0.0",
    "@typescript-eslint/parser": "^5.0.0",
    "eslint": "^8.0.0",
    "jest": "^28.1.1",
    "ts-jest": "^28.0.8",
    "ts-loader": "^9.2.6",
    "typescript": "^4.6.4"
  },
  "jest": {
    "moduleFileExtensions": ["js","json","ts"],
    "rootDir": "src",
    "testRegex": ".*\\.spec\\.ts$",
    "transform": {
      "^.+\\.(t|j)s$": "ts-jest"
    },
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  }
}
EOF

# tsconfig.json
cat <<EOF > tsconfig.json
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
EOF

# nest-cli.json
cat <<EOF > nest-cli.json
{
  "collection": "@nestjs/schematics",
  "sourceRoot": "src"
}
EOF

# .env (con credenciales MySQL, Stripe, JWT, placeholders para Agora)
cat <<EOF > .env
# MySQL
DB_HOST=localhost
DB_PORT=3306
DB_USER=ubuntu
DB_PASSWORD=paczug-beGkov-0syvci
DB_NAME=coreadmin

# JWT
JWT_SECRET=DialoomJWTSecret

# Stripe (test)
STRIPE_SECRET_KEY=sk_test_XXXXXXXX

# Agora
AGORA_APP_ID=d553a1e4f2434064951d6ef117d32750
AGORA_APP_CERT=59d23aa57a204028959f93e06e0ff204

# Retention for Payment
PAYMENT_RETENTION_DAYS=7

# Email Plesk SMTP example
SMTP_HOST=localhost
SMTP_PORT=25
SMTP_USER=
SMTP_PASS=

# Redis optional
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
EOF

# src/main.ts
cat <<'EOF' > src/main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import helmet from 'helmet';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Helmet para seguridad
  app.use(helmet());

  // Validation global
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, transform: true }));

  // CORS
  app.enableCors();

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`Dialoom running on port ${port}`);
}
bootstrap();
EOF

# src/app.module.ts
cat <<'EOF' > src/app.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { MailerModule } from './modules/mailer/mailer.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        type: 'mysql',
        host: config.get<string>('DB_HOST'),
        port: config.get<number>('DB_PORT'),
        username: config.get<string>('DB_USER'),
        password: config.get<string>('DB_PASSWORD'),
        database: config.get<string>('DB_NAME'),
        entities: [__dirname + '/modules/**/*.entity.{ts,js}'],
        synchronize: false,
      }),
    }),
    // Módulos iniciales
    AuthModule,
    UsersModule,
    PaymentsModule,
    MailerModule, // placeholder para correo
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
EOF

#####################################
# AuthModule (JWT, local password)
#####################################

# src/modules/auth/auth.module.ts
cat <<'EOF' > src/modules/auth/auth.module.ts
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service';
import { JwtStrategy } from './jwt.strategy';

@Module({
  imports: [
    ConfigModule,
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (cfg: ConfigService) => ({
        secret: cfg.get<string>('JWT_SECRET'),
        signOptions: { expiresIn: '1h' },
      }),
    }),
  ],
  providers: [AuthService, JwtStrategy],
  exports: [AuthService],
})
export class AuthModule {}
EOF

# src/modules/auth/auth.service.ts
cat <<'EOF' > src/modules/auth/auth.service.ts
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    private jwtService: JwtService
  ) {}

  /**
   * validateUser:
   * - Compara la password con el hash.
   * - Retorna true o false (o un user object) según convenga.
   */
  async validateUser(passwordPlain: string, passwordHash: string): Promise<boolean> {
    const match = await bcrypt.compare(passwordPlain, passwordHash);
    if (!match) {
      throw new UnauthorizedException('Invalid password');
    }
    return true;
  }

  /**
   * Genera token JWT
   */
  generateToken(payload: { userId: number; role: string }) {
    return this.jwtService.sign(payload);
  }
}
EOF

# src/modules/auth/jwt.strategy.ts
cat <<'EOF' > src/modules/auth/jwt.strategy.ts
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy, ExtractJwt } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || 'DialoomJWTSecret',
    });
  }

  async validate(payload: any) {
    // Podrías buscar el usuario en DB, etc.
    if (!payload.userId) {
      throw new UnauthorizedException('Token inválido');
    }
    return payload; // user object in request
  }
}
EOF

####################################
# UsersModule
####################################
# src/modules/users/users.module.ts
cat <<'EOF' > src/modules/users/users.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { UsersService } from './users.service';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
EOF

# src/modules/users/entities/user.entity.ts
cat <<'EOF' > src/modules/users/entities/user.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

export enum UserRole {
  USER = 'user',
  HOST = 'host',
  ADMIN = 'admin',
  SUPERADMIN = 'superadmin',
}

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  name!: string;

  @Column({ unique: true })
  email!: string;

  @Column({ nullable: true })
  passwordHash?: string;

  @Column({ type: 'enum', enum: UserRole, default: UserRole.USER })
  role!: UserRole;

  @CreateDateColumn()
  createdAt!: Date;
}
EOF

# src/modules/users/users.service.ts
cat <<'EOF' > src/modules/users/users.service.ts
import { Injectable, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from './entities/user.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private usersRepo: Repository<User>,
  ) {}

  async createUser(name: string, email: string, passwordPlain: string, role: UserRole = UserRole.USER) {
    // Ver si el email ya existe
    const existing = await this.usersRepo.findOne({ where: { email } });
    if (existing) {
      throw new ConflictException('Email already in use');
    }
    const passwordHash = await bcrypt.hash(passwordPlain, 10);

    const newUser = this.usersRepo.create({
      name,
      email,
      passwordHash,
      role,
    });
    return this.usersRepo.save(newUser);
  }

  async findByEmail(email: string) {
    return this.usersRepo.findOne({ where: { email } });
  }

  async findById(id: number) {
    return this.usersRepo.findOne({ where: { id } });
  }
}
EOF

####################################
# PaymentModule (básico, sin retención)
####################################
# src/modules/payments/payments.module.ts
cat <<'EOF' > src/modules/payments/payments.module.ts
import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { StripeService } from './stripe.service';

@Module({
  imports: [],
  providers: [StripeService, ConfigService],
  exports: [StripeService],
})
export class PaymentsModule {}
EOF

# src/modules/payments/stripe.service.ts
cat <<'EOF' > src/modules/payments/stripe.service.ts
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';

/**
 * StripeService:
 *  - Versión simple para cobros básicos.
 *  - A futuro: retenciones, payouts, etc. (en la parte 6).
 */
@Injectable()
export class StripeService {
  private stripeClient: Stripe;

  constructor(private config: ConfigService) {
    const secretKey = this.config.get<string>('STRIPE_SECRET_KEY') || 'sk_test_XXX';
    this.stripeClient = new Stripe(secretKey, {
      apiVersion: '2022-11-15',
    });
  }

  async createCharge(amount: number, currency = 'USD', sourceToken: string, description = 'Dialoom charge') {
    // Mínimo ejemplo
    return this.stripeClient.charges.create({
      amount,
      currency,
      source: sourceToken,
      description,
    });
  }
}
EOF

####################################
# MailerModule (placeholder, SMTP Plesk)
####################################
# src/modules/mailer/mailer.module.ts
cat <<'EOF' > src/modules/mailer/mailer.module.ts
import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { MailerService } from './mailer.service';

@Module({
  providers: [MailerService, ConfigService],
  exports: [MailerService],
})
export class MailerModule {}
EOF

# src/modules/mailer/mailer.service.ts
cat <<'EOF' > src/modules/mailer/mailer.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import nodemailer from 'nodemailer';

@Injectable()
export class MailerService {
  private logger = new Logger(MailerService.name);

  constructor(private config: ConfigService) {}

  async sendMail(to: string, subject: string, text: string) {
    const host = this.config.get<string>('SMTP_HOST') || 'localhost';
    const port = this.config.get<number>('SMTP_PORT') || 25;
    const user = this.config.get<string>('SMTP_USER') || '';
    const pass = this.config.get<string>('SMTP_PASS') || '';

    // crear transporter
    const transporter = nodemailer.createTransport({
      host,
      port,
      secure: false,
      auth: user && pass ? { user, pass } : undefined,
    });

    const info = await transporter.sendMail({
      from: '"Dialoom" <no-reply@dialoom.com>',
      to,
      subject,
      text,
      // html, attachments, etc. future
    });
    this.logger.log(`Email sent to ${to}, messageId=${info.messageId}`);
    return info;
  }
}
EOF

####################################
echo "==> Estructura generada OK (Part 1: Arquitectura + Auth)."
echo "Revisa .env, actualiza credenciales MySQL, Stripe, etc. Luego:"
echo "cd dialoom-backend"
echo "npm install"
echo "npm run build && npm run start"
echo ""
echo "Este es el esqueleto para los apartados 2 y 3. Próximamente agregaremos"
echo "Roles y Funcionalidades, Reservas/Videollamadas, Pagos con retención, etc."
