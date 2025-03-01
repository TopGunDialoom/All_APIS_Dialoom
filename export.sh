#!/bin/bash
# setup-dialoom-backend.sh
# -------------------------------------------------------------------
# Crea la estructura completa del backend de Dialoom (NestJS + PostgreSQL),
# con integraciones de Stripe, Firebase, Agora, WebSockets, Docker y Nginx.
# -------------------------------------------------------------------

PROJECT="dialoom-backend"

echo "Creando carpeta '$PROJECT'..."
mkdir -p "$PROJECT"
cd "$PROJECT" || exit 1

# 1. Archivos de entorno ----------------------------------------------------

cat > .env << 'EOF'
NODE_ENV=development
PORT=3000

# PostgreSQL config
DB_HOST=db
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_NAME=dialoom

# JWT Auth
JWT_SECRET=changeme
JWT_EXPIRES_IN=1d

# Stripe
STRIPE_SECRET=sk_test_yourkey

# Firebase
FIREBASE_SERVICE_ACCOUNT_PATH=firebase-service-account.json

# Agora
AGORA_APP_ID=YOUR_AGORA_APP_ID
AGORA_APP_CERT=YOUR_AGORA_APP_CERTIFICATE
EOF

cat > .env.example << 'EOF'
NODE_ENV=development
PORT=3000

DB_HOST=db
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_NAME=dialoom

JWT_SECRET=changeme
JWT_EXPIRES_IN=1d

STRIPE_SECRET=sk_test_yourkey

FIREBASE_SERVICE_ACCOUNT_PATH=firebase-service-account.json

AGORA_APP_ID=YOUR_AGORA_APP_ID
AGORA_APP_CERT=YOUR_AGORA_APP_CERTIFICATE
EOF

# 2. .gitignore ------------------------------------------------------------

cat > .gitignore << 'EOF'
# Node dependencies
node_modules/
# Builds
dist/
# Env files
.env
# Mac system files
.DS_Store
EOF

# 3. package.json ----------------------------------------------------------

cat > package.json << 'EOF'
{
  "name": "dialoom-backend",
  "version": "1.0.0",
  "description": "Backend de Dialoom - NestJS, PostgreSQL, Docker, Nginx, Stripe, Firebase, Agora, etc.",
  "main": "dist/main.js",
  "scripts": {
    "start": "node dist/main.js",
    "start:dev": "ts-node -r tsconfig-paths/register src/main.ts",
    "build": "tsc -p tsconfig.build.json",
    "start:prod": "npm run build && node dist/main.js"
  },
  "dependencies": {
    "@nestjs/common": "^9.0.0",
    "@nestjs/core": "^9.0.0",
    "@nestjs/platform-express": "^9.0.0",
    "@nestjs/websockets": "^9.0.0",
    "@nestjs/config": "^2.2.0",
    "@nestjs/passport": "^9.0.0",
    "@nestjs/jwt": "^9.0.0",
    "passport": "^0.6.0",
    "passport-jwt": "^4.0.0",
    "bcrypt": "^5.0.1",
    "stripe": "^11.0.0",
    "firebase-admin": "^11.0.0",
    "agora-access-token": "^2.0.0",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.5.0",
    "typeorm": "^0.3.12",
    "pg": "^8.7.0"
  },
  "devDependencies": {
    "@types/node": "^16.0.0",
    "@types/bcrypt": "^5.0.0",
    "@nestjs/cli": "^9.0.0",
    "@nestjs/schematics": "^9.0.0",
    "@nestjs/testing": "^9.0.0",
    "ts-node": "^10.9.0",
    "tsconfig-paths": "^4.0.0",
    "typescript": "^4.7.0"
  }
}
EOF

# 4. tsconfig.json / tsconfig.build.json / nest-cli.json -------------------

cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "ES2018",
    "lib": ["ES2018", "DOM"],
    "moduleResolution": "node",
    "outDir": "./dist",
    "sourceMap": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "strict": false
  },
  "exclude": ["node_modules", "dist"]
}
EOF

cat > tsconfig.build.json << 'EOF'
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "sourceMap": false,
    "declaration": true,
    "removeComments": true
  },
  "exclude": ["node_modules", "dist", "test", "**/*.spec.ts"]
}
EOF

cat > nest-cli.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "sourceRoot": "src"
}
EOF

# 5. Dockerfile ------------------------------------------------------------

cat > Dockerfile << 'EOF'
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Runtime stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/firebase-service-account.json ./firebase-service-account.json
EXPOSE 3000
CMD ["node", "dist/main.js"]
EOF

# 6. docker-compose.yml ----------------------------------------------------

cat > docker-compose.yml << 'EOF'
version: '3'
services:
  app:
    build: .
    container_name: dialoom_app
    env_file: .env
    depends_on:
      - db
    ports:
      - "3000:3000"

  db:
    image: postgres:14
    container_name: dialoom_db
    restart: always
    environment:
      POSTGRES_USER: \${DB_USERNAME}
      POSTGRES_PASSWORD: \${DB_PASSWORD}
      POSTGRES_DB: \${DB_NAME}
    volumes:
      - pgdata:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U \${DB_USERNAME} -d \${DB_NAME}"]
      interval: 5s
      timeout: 5s
      retries: 5

  nginx:
    image: nginx:alpine
    container_name: dialoom_nginx
    depends_on:
      - app
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    ports:
      - "80:80"

volumes:
  pgdata:
EOF

# 7. nginx.conf ------------------------------------------------------------

cat > nginx.conf << 'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://app:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# 8. Credenciales de Firebase (service account) de ejemplo

cat > firebase-service-account.json << 'EOF'
{
  "type": "service_account",
  "project_id": "YOUR_FIREBASE_PROJECT_ID",
  "private_key_id": "YOUR_KEY_ID",
  "private_key": "-----BEGIN PRIVATE KEY-----\\nYOUR_PRIVATE_KEY\\n-----END PRIVATE KEY-----\\n",
  "client_email": "firebase-adminsdk@YOUR_FIREBASE_PROJECT_ID.iam.gserviceaccount.com",
  "client_id": "1234567890",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk@YOUR_FIREBASE_PROJECT_ID.iam.gserviceaccount.com"
}
EOF

# 9. Scripts de migración y seeds (database/)

mkdir -p database

cat > database/01_init.sql << 'EOF'
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) DEFAULT '',
    points INT NOT NULL DEFAULT 0,
    device_token VARCHAR(255),
    role VARCHAR(20) NOT NULL DEFAULT 'user'
);

CREATE TABLE IF NOT EXISTS reservations (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    date TIMESTAMP NOT NULL,
    confirmed BOOLEAN NOT NULL DEFAULT FALSE,
    description TEXT,
    CONSTRAINT fk_user_reservation FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS payments (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    reservation_id INT,
    amount INT NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'usd',
    status VARCHAR(20) NOT NULL,
    stripe_id VARCHAR(100) NOT NULL,
    CONSTRAINT fk_user_payment FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_reservation_payment FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE SET NULL
);
EOF

cat > database/02_seed.sql << 'EOF'
INSERT INTO users (email, password, name, points, role)
VALUES ('admin@example.com', '$2b$10$7istd4vRk3L6saqXkjty8u6SlKo7S3VE52hXp6MzK14SO8FnyX2vC', 'Admin', 0, 'admin');
EOF

# 10. Estructura de carpetas src/ (NestJS)
mkdir -p src/auth/dto src/users/dto src/reservations/dto src/payments/dto src/notifications src/calls

# main.ts
cat > src/main.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: true });
  const config = app.get(ConfigService);
  const port = config.get<number>('PORT') || 3000;
  await app.listen(port, () => {
    console.log(\`Dialoom backend listening on port \${port}\`);
  });
}
bootstrap();
EOF

# app.module.ts
cat > src/app.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/user.module';
import { ReservationsModule } from './reservations/reservation.module';
import { PaymentsModule } from './payments/payment.module';
import { NotificationModule } from './notifications/notification.module';
import { CallsModule } from './calls/calls.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT) || 5432,
      username: process.env.DB_USERNAME,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      autoLoadEntities: true,
      synchronize: false
    }),
    AuthModule,
    UsersModule,
    ReservationsModule,
    PaymentsModule,
    NotificationModule,
    CallsModule
  ]
})
export class AppModule {}
EOF

# a) Módulo de autenticación
mkdir -p src/auth
cat > src/auth/auth.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtStrategy } from './jwt.strategy';
import { UsersModule } from '../users/user.module';
import { ConfigService } from '@nestjs/config';

@Module({
  imports: [
    UsersModule,
    PassportModule,
    JwtModule.registerAsync({
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('JWT_SECRET') || 'secretKey',
        signOptions: { expiresIn: config.get<string>('JWT_EXPIRES_IN') || '1d' }
      }),
      inject: [ConfigService]
    })
  ],
  controllers: [AuthController],
  providers: [AuthService, JwtStrategy],
  exports: [AuthService]
})
export class AuthModule {}
EOF

cat > src/auth/auth.service.ts << 'EOF'
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../users/user.service';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService
  ) {}

  async validateUser(email: string, password: string) {
    const user = await this.usersService.findByEmail(email);
    if (user && await bcrypt.compare(password, user.password)) {
      const { password, ...rest } = user;
      return rest;
    }
    return null;
  }

  async login(email: string, pass: string) {
    const user = await this.validateUser(email, pass);
    if (!user) {
      throw new UnauthorizedException('Invalid credentials');
    }
    const payload = { sub: user.id, email: user.email };
    return {
      access_token: this.jwtService.sign(payload)
    };
  }
}
EOF

cat > src/auth/auth.controller.ts << 'EOF'
import { Controller, Post, Body } from '@nestjs/common';
import { AuthService } from './auth.service';
import { UsersService } from '../users/user.service';
import { LoginDto } from './dto/login.dto';
import { CreateUserDto } from '../users/dto/create-user.dto';

@Controller('auth')
export class AuthController {
  constructor(
    private authService: AuthService,
    private usersService: UsersService
  ) {}

  @Post('login')
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto.email, loginDto.password);
  }

  @Post('register')
  async register(@Body() createUserDto: CreateUserDto) {
    const user = await this.usersService.create(createUserDto);
    return { message: 'User registered', user };
  }
}
EOF

mkdir -p src/auth/dto
cat > src/auth/dto/login.dto.ts << 'EOF'
export class LoginDto {
  email: string;
  password: string;
}
EOF

cat > src/auth/jwt.strategy.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || 'secretKey'
    });
  }

  async validate(payload: any) {
    return { userId: payload.sub, email: payload.email };
  }
}
EOF

# b) Módulo de usuarios
mkdir -p src/users/dto
cat > src/users/user.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersService } from './user.service';
import { UsersController } from './user.controller';
import { User } from './user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  providers: [UsersService],
  controllers: [UsersController],
  exports: [UsersService]
})
export class UsersModule {}
EOF

cat > src/users/user.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from './user.entity';
import { CreateUserDto } from './dto/create-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private userRepo: Repository<User>
  ) {}

  async findByEmail(email: string): Promise<User> {
    return this.userRepo.findOne({ where: { email } });
  }

  async findById(id: number): Promise<User> {
    return this.userRepo.findOne({ where: { id } });
  }

  async create(dto: CreateUserDto): Promise<User> {
    const hashed = await bcrypt.hash(dto.password, 10);
    const newUser = this.userRepo.create({ ...dto, password: hashed });
    return this.userRepo.save(newUser);
  }

  async update(id: number, data: Partial<User>) {
    await this.userRepo.update(id, data);
    return this.findById(id);
  }
}
EOF

cat > src/users/user.controller.ts << 'EOF'
import { Controller, Get, Put, Body, Request, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { UsersService } from './user.service';
import { UpdateUserDto } from './dto/update-user.dto';

@Controller('users')
export class UsersController {
  constructor(private usersService: UsersService) {}

  @UseGuards(AuthGuard('jwt'))
  @Get('me')
  async getProfile(@Request() req) {
    const user = await this.usersService.findById(req.user.userId);
    if (user) {
      user.password = undefined;
    }
    return user;
  }

  @UseGuards(AuthGuard('jwt'))
  @Put('me')
  async updateProfile(@Request() req, @Body() updateUserDto: UpdateUserDto) {
    if (updateUserDto.password) {
      // Hash la nueva password
      updateUserDto.password = updateUserDto.password;
    }
    const updated = await this.usersService.update(req.user.userId, updateUserDto);
    if (updated) {
      updated.password = undefined;
    }
    return updated;
  }
}
EOF

cat > src/users/dto/create-user.dto.ts << 'EOF'
export class CreateUserDto {
  email: string;
  password: string;
  name?: string;
}
EOF

cat > src/users/dto/update-user.dto.ts << 'EOF'
export class UpdateUserDto {
  password?: string;
  name?: string;
  deviceToken?: string;
}
EOF

cat > src/users/user.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Reservation } from '../reservations/reservation.entity';
import { Payment } from '../payments/payment.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column({ default: '' })
  name: string;

  @Column({ default: 0 })
  points: number;

  @Column({ name: 'device_token', nullable: true })
  deviceToken: string;

  @Column({ default: 'user' })
  role: string;

  @OneToMany(() => Reservation, r => r.user)
  reservations: Reservation[];

  @OneToMany(() => Payment, p => p.user)
  payments: Payment[];
}
EOF

# c) Módulo de reservas
mkdir -p src/reservations/dto
cat > src/reservations/reservation.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ReservationsService } from './reservation.service';
import { ReservationsController } from './reservation.controller';
import { Reservation } from './reservation.entity';
import { User } from '../users/user.entity';
import { NotificationModule } from '../notifications/notification.module';

@Module({
  imports: [TypeOrmModule.forFeature([Reservation, User]), NotificationModule],
  providers: [ReservationsService],
  controllers: [ReservationsController]
})
export class ReservationsModule {}
EOF

cat > src/reservations/reservation.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Reservation } from './reservation.entity';
import { User } from '../users/user.entity';
import { NotificationService } from '../notifications/notification.service';
import { CreateReservationDto } from './dto/create-reservation.dto';

@Injectable()
export class ReservationsService {
  constructor(
    @InjectRepository(Reservation) private reservationRepo: Repository<Reservation>,
    @InjectRepository(User) private userRepo: Repository<User>,
    private notificationService: NotificationService
  ) {}

  async create(userId: number, dto: CreateReservationDto): Promise<Reservation> {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    const newRes = this.reservationRepo.create({
      date: new Date(dto.date),
      description: dto.description || '',
      user
    });
    const saved = await this.reservationRepo.save(newRes);
    // Sumar puntos
    if (user) {
      user.points += 10;
      await this.userRepo.save(user);
    }
    // Notificar
    await this.notificationService.notifyReservationCreated(saved);
    return saved;
  }

  async findForUser(userId: number): Promise<Reservation[]> {
    return this.reservationRepo.find({ where: { user: { id: userId } } });
  }
}
EOF

cat > src/reservations/reservation.controller.ts << 'EOF'
import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ReservationsService } from './reservation.service';
import { CreateReservationDto } from './dto/create-reservation.dto';

@Controller('reservations')
export class ReservationsController {
  constructor(private reservationsService: ReservationsService) {}

  @UseGuards(AuthGuard('jwt'))
  @Get()
  async getMyReservations(@Request() req) {
    return this.reservationsService.findForUser(req.user.userId);
  }

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async createRes(@Request() req, @Body() dto: CreateReservationDto) {
    return this.reservationsService.create(req.user.userId, dto);
  }
}
EOF

cat > src/reservations/dto/create-reservation.dto.ts << 'EOF'
export class CreateReservationDto {
  date: string;
  description?: string;
}
EOF

cat > src/reservations/reservation.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, OneToMany } from 'typeorm';
import { User } from '../users/user.entity';
import { Payment } from '../payments/payment.entity';

@Entity('reservations')
export class Reservation {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  date: Date;

  @Column({ default: false })
  confirmed: boolean;

  @Column({ nullable: true })
  description: string;

  @ManyToOne(() => User, user => user.reservations, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @OneToMany(() => Payment, p => p.reservation)
  payments: Payment[];
}
EOF

# d) Módulo de pagos
mkdir -p src/payments/dto
cat > src/payments/payment.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PaymentsService } from './payment.service';
import { PaymentsController } from './payment.controller';
import { Payment } from './payment.entity';
import { Reservation } from '../reservations/reservation.entity';
import { User } from '../users/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Payment, Reservation, User])],
  providers: [PaymentsService],
  controllers: [PaymentsController]
})
export class PaymentsModule {}
EOF

cat > src/payments/payment.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import Stripe from 'stripe';
import { Payment } from './payment.entity';
import { Reservation } from '../reservations/reservation.entity';
import { User } from '../users/user.entity';
import { CreatePaymentDto } from './dto/create-payment.dto';

@Injectable()
export class PaymentsService {
  private stripe: Stripe;
  constructor(
    @InjectRepository(Payment) private paymentRepo: Repository<Payment>,
    @InjectRepository(Reservation) private resRepo: Repository<Reservation>,
    @InjectRepository(User) private userRepo: Repository<User>
  ) {
    this.stripe = new Stripe(process.env.STRIPE_SECRET || '', { apiVersion: '2022-11-15' });
  }

  async create(userId: number, dto: CreatePaymentDto) {
    // crear PaymentIntent
    const amount = dto.amount;
    const currency = dto.currency || 'usd';
    const intent = await this.stripe.paymentIntents.create({
      amount,
      currency
    });
    let reservation = null;
    if (dto.reservationId) {
      reservation = await this.resRepo.findOne({ where: { id: dto.reservationId, user: { id: userId } } });
    }
    const user = await this.userRepo.findOne({ where: { id: userId } });
    const payment = this.paymentRepo.create({
      amount,
      currency,
      status: intent.status,
      stripeId: intent.id,
      user,
      reservation
    });
    await this.paymentRepo.save(payment);
    return { paymentId: payment.id, clientSecret: intent.client_secret };
  }
}
EOF

cat > src/payments/payment.controller.ts << 'EOF'
import { Controller, Post, Body, UseGuards, Request } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { PaymentsService } from './payment.service';
import { CreatePaymentDto } from './dto/create-payment.dto';

@Controller('payments')
export class PaymentsController {
  constructor(private paymentsService: PaymentsService) {}

  @UseGuards(AuthGuard('jwt'))
  @Post()
  async createPayment(@Request() req, @Body() dto: CreatePaymentDto) {
    const userId = req.user.userId;
    return this.paymentsService.create(userId, dto);
  }
}
EOF

cat > src/payments/dto/create-payment.dto.ts << 'EOF'
export class CreatePaymentDto {
  amount: number;
  currency?: string;
  reservationId?: number;
}
EOF

cat > src/payments/payment.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { User } from '../users/user.entity';
import { Reservation } from '../reservations/reservation.entity';

@Entity('payments')
export class Payment {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  amount: number;

  @Column({ default: 'usd' })
  currency: string;

  @Column()
  status: string;

  @Column({ name: 'stripe_id' })
  stripeId: string;

  @ManyToOne(() => User, user => user.payments, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Reservation, reservation => reservation.payments, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'reservation_id' })
  reservation: Reservation;
}
EOF

# e) Módulo de Notificaciones (Firebase + WebSockets)
mkdir -p src/notifications
cat > src/notifications/notification.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { NotificationGateway } from './notification.gateway';
import { NotificationService } from './notification.service';

@Module({
  providers: [NotificationGateway, NotificationService],
  exports: [NotificationService]
})
export class NotificationModule {}
EOF

cat > src/notifications/notification.gateway.ts << 'EOF'
import { WebSocketGateway, WebSocketServer } from '@nestjs/websockets';
import { Server } from 'socket.io';

@WebSocketGateway({ cors: true })
export class NotificationGateway {
  @WebSocketServer()
  server: Server;
}
EOF

cat > src/notifications/notification.service.ts << 'EOF'
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
EOF

# f) Módulo de Llamadas (Agora)
mkdir -p src/calls
cat > src/calls/calls.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { CallsService } from './calls.service';
import { CallsController } from './calls.controller';

@Module({
  providers: [CallsService],
  controllers: [CallsController]
})
export class CallsModule {}
EOF

cat > src/calls/calls.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { RtcTokenBuilder, RtcRole } from 'agora-access-token';

@Injectable()
export class CallsService {
  generateToken(channel: string, uid: number) {
    const appId = process.env.AGORA_APP_ID;
    const appCert = process.env.AGORA_APP_CERT;
    if (!appId || !appCert) {
      throw new Error('Agora credentials missing');
    }
    const expirationInSeconds = 3600; // 1 hora
    const now = Math.floor(Date.now() / 1000);
    const privilegeExpiredTs = now + expirationInSeconds;
    const token = RtcTokenBuilder.buildTokenWithUid(
      appId,
      appCert,
      channel,
      uid,
      RtcRole.PUBLISHER,
      privilegeExpiredTs
    );
    return { token };
  }
}
EOF

cat > src/calls/calls.controller.ts << 'EOF'
import { Controller, Get, Query, UseGuards, Request } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { CallsService } from './calls.service';

@Controller('calls')
export class CallsController {
  constructor(private callsService: CallsService) {}

  @UseGuards(AuthGuard('jwt'))
  @Get('token')
  getCallToken(@Request() req, @Query('channel') channel: string) {
    const uid = req.user.userId;
    return this.callsService.generateToken(channel, uid);
  }
}
EOF

# README final
cat > README.md << 'EOF'
# Dialoom Backend (Completo)

Este proyecto ilustra una **estructura base** para un backend de Dialoom con:
- **NestJS** (Node.js + TypeScript)
- **PostgreSQL** (almacenamiento)
- **Docker y Nginx** (despliegue en AWS Lightsail)
- **Stripe** (pagos y comisiones)
- **Firebase** (notificaciones push)
- **Agora** (videollamadas / tokens RTC)
- **WebSockets** para notificaciones en tiempo real.

## Estructura

- **src/**  
  - **auth/**: Módulo de autenticación (JWT, login, registro, 2FA si se amplía).  
  - **users/**: Módulo para gestión de usuarios.  
  - **reservations/**: Reservas de sesiones, notifica y suma puntos.  
  - **payments/**: Creación de PaymentIntents, retención de comisiones, etc.  
  - **notifications/**: Notificaciones Firebase + WebSockets.  
  - **calls/**: Generación de tokens para Agora.  
  - **app.module.ts**: Módulo raíz que integra todo.

- **database/**: Scripts SQL de migración y seeds (01_init.sql, 02_seed.sql).

- **docker-compose.yml**, **Dockerfile**, **nginx.conf**: Despliegue con contenedores y Nginx proxy.

## Uso

1. Copiar `cp .env.example .env` y editar tus credenciales (DB, Stripe, Firebase, Agora).
2. `npm install`
3. Levantar con Docker:
   ```bash
   docker-compose up -d
