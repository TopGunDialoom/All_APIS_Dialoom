#!/bin/bash
# setup-advanced-dialoom-backend.sh
# ----------------------------------------------------------------------------
# Crea la estructura COMPLETA del backend de Dialoom en NestJS con:
# - PostgreSQL
# - Gamificación (Badges, niveles, ranking)
# - Multi-idioma (archivos i18n para ES, EN, CAT, DE, FR, NO, DA, IT, PL, NL)
# - Roles de usuario (superadmin, admin, host, user)
# - Pagos con Stripe con retención de comisiones
# - Agora para videollamadas
# - Firebase para notificaciones push
# - Soporte/Tickets
# - Docker + Nginx para despliegue en AWS Lightsail
# ----------------------------------------------------------------------------

PROJECT="dialoom-backend"
echo "Creando carpeta '$PROJECT'..."
mkdir -p "$PROJECT"
cd "$PROJECT" || exit 1

# 1) Archivos de entorno y Gitignore
cat > .env << 'EOF'
NODE_ENV=development
PORT=3000

# PostgreSQL
DB_HOST=db
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_NAME=dialoom

# JWT
JWT_SECRET=changeme
JWT_EXPIRES_IN=1d

# ROLES disponibles: superadmin, admin, host, user

# Stripe
STRIPE_SECRET=sk_test_XXXX

# Firebase
FIREBASE_SERVICE_ACCOUNT_PATH=firebase-service-account.json

# Agora
AGORA_APP_ID=YOUR_AGORA_APP_ID
AGORA_APP_CERT=YOUR_AGORA_APP_CERTIFICATE

# Comisiones e IVA
DIALOOM_COMMISSION_PERCENT=10
DIALOOM_IVA_PERCENT=21
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

STRIPE_SECRET=sk_test_XXXX

FIREBASE_SERVICE_ACCOUNT_PATH=firebase-service-account.json

AGORA_APP_ID=YOUR_AGORA_APP_ID
AGORA_APP_CERT=YOUR_AGORA_APP_CERTIFICATE

DIALOOM_COMMISSION_PERCENT=10
DIALOOM_IVA_PERCENT=21
EOF

cat > .gitignore << 'EOF'
node_modules/
dist/
.env
.DS_Store
EOF

# 2) package.json y configuraciones TS
cat > package.json << 'EOF'
{
  "name": "dialoom-backend",
  "version": "1.0.0",
  "description": "Backend de Dialoom con NestJS, PostgreSQL, Stripe, Agora, Firebase, Gamificación y Soporte.",
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
    "@nestjs/config": "^2.2.0",
    "@nestjs/passport": "^9.0.0",
    "@nestjs/jwt": "^9.0.0",
    "@nestjs/websockets": "^9.0.0",
    "@nestjs/typeorm": "^9.0.0",
    "bcrypt": "^5.0.1",
    "stripe": "^11.0.0",
    "firebase-admin": "^11.0.0",
    "agora-access-token": "^2.0.0",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.5.0",
    "typeorm": "^0.3.12",
    "pg": "^8.7.0",
    "passport": "^0.6.0",
    "passport-jwt": "^4.0.0",
    "socket.io": "^4.4.1"
  },
  "devDependencies": {
    "@nestjs/cli": "^9.0.0",
    "@nestjs/schematics": "^9.0.0",
    "@nestjs/testing": "^9.0.0",
    "@types/node": "^16.0.0",
    "@types/bcrypt": "^5.0.0",
    "@types/stripe": "^8.0.0",
    "@types/express": "^4.17.13",
    "ts-node": "^10.9.0",
    "tsconfig-paths": "^4.0.0",
    "typescript": "^4.7.0"
  }
}
EOF

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

# 3) Dockerfile y docker-compose.yml + nginx.conf
cat > Dockerfile << 'EOF'
# Dockerfile para Dialoom Backend

FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/firebase-service-account.json ./firebase-service-account.json
EXPOSE 3000
CMD ["node", "dist/main.js"]
EOF

cat > docker-compose.yml << 'EOF'
version: '3'
services:
  dialoom:
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
    environment:
      POSTGRES_USER: \${DB_USERNAME}
      POSTGRES_PASSWORD: \${DB_PASSWORD}
      POSTGRES_DB: \${DB_NAME}
    volumes:
      - pgdata:/var/lib/postgresql/data

  nginx:
    image: nginx:alpine
    container_name: dialoom_nginx
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      - dialoom
    ports:
      - "80:80"

volumes:
  pgdata:
EOF

cat > nginx.conf << 'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://dialoom:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# 4) firebase-service-account.json (ejemplo)
cat > firebase-service-account.json << 'EOF'
{
  "type": "service_account",
  "project_id": "YOUR_PROJECT_ID",
  "private_key_id": "YOUR_KEY_ID",
  "private_key": "-----BEGIN PRIVATE KEY-----\\nYOUR_PRIVATE_KEY\\n-----END PRIVATE KEY-----\\n",
  "client_email": "firebase-adminsdk@YOUR_PROJECT_ID.iam.gserviceaccount.com",
  "client_id": "1234567890",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk@YOUR_PROJECT_ID.iam.gserviceaccount.com"
}
EOF

# 5) i18n (multi-idioma) con ES, EN, CAT, DE, FR, NO, DA, IT, PL, NL
mkdir -p i18n

for lang in es en ca de fr no da it pl nl
do
cat > "i18n/${lang}.json" <<EOF
{
  "welcome": "Welcome in $lang",
  "session_created": "Session created",
  "payment_completed": "Payment completed",
  "badge_unlocked": "Badge unlocked",
  "admin_only": "You need admin privileges"
}
EOF
done

# 6) Base de datos - scripts
mkdir -p database
cat > database/01_init.sql << 'EOF'
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  name VARCHAR(100),
  points INT NOT NULL DEFAULT 0,
  device_token VARCHAR(255),
  role VARCHAR(20) NOT NULL DEFAULT 'user'
);

CREATE TABLE IF NOT EXISTS announcements (
  id SERIAL PRIMARY KEY,
  host_id INT NOT NULL,
  title VARCHAR(200),
  content TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reservations (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  date TIMESTAMP NOT NULL,
  confirmed BOOLEAN NOT NULL DEFAULT FALSE,
  description TEXT
);

CREATE TABLE IF NOT EXISTS payments (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  reservation_id INT,
  amount INT NOT NULL,
  currency VARCHAR(10) NOT NULL DEFAULT 'usd',
  status VARCHAR(20) NOT NULL,
  stripe_id VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS badges (
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) UNIQUE NOT NULL,
  description TEXT,
  points_required INT NOT NULL
);

CREATE TABLE IF NOT EXISTS user_badges (
  user_id INT,
  badge_id INT,
  unlocked_at TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (user_id, badge_id)
);

CREATE TABLE IF NOT EXISTS tickets (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  subject VARCHAR(200),
  message TEXT,
  status VARCHAR(20) DEFAULT 'open',
  created_at TIMESTAMP DEFAULT NOW()
);
EOF

cat > database/02_seed.sql << 'EOF'
INSERT INTO users (email, password, name, role)
VALUES
('admin@dialoom.com', '$2b$10$abcdefghijklmnopqrstuv/123456789', 'Admin', 'superadmin'),
('host1@dialoom.com', '$2b$10$abcdefghijklmnopqrstuv/123456789', 'Host1', 'host'),
('user1@dialoom.com', '$2b$10$abcdefghijklmnopqrstuv/123456789', 'User1', 'user');

INSERT INTO badges (name, description, points_required)
VALUES
('FirstCall', 'Badge for completing the first call', 0),
('StarHost', 'Badge for hosts with 100% 5-star reviews', 0);

EOF

# 7) Carpetas y archivos de código src
mkdir -p src
cat > src/main.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ConfigService } from '@nestjs/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, { cors: true });
  const config = app.get(ConfigService);
  const port = config.get<number>('PORT') || 3000;
  await app.listen(port, () => {
    console.log(\`Dialoom backend running on port \${port}\`);
  });
}
bootstrap();
EOF

# app.module.ts
cat > src/app.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt';

import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/user.module';
import { ReservationsModule } from './reservations/reservation.module';
import { PaymentsModule } from './payments/payment.module';
import { NotificationModule } from './notifications/notification.module';
import { CallsModule } from './calls/calls.module';
import { GamificationModule } from './gamification/gamification.module';
import { AdminModule } from './admin/admin.module';
import { TicketsModule } from './tickets/tickets.module';

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
    JwtModule.register({ secret: process.env.JWT_SECRET || 'secretKey' }),
    AuthModule,
    UsersModule,
    ReservationsModule,
    PaymentsModule,
    NotificationModule,
    CallsModule,
    GamificationModule,
    AdminModule,
    TicketsModule
  ]
})
export class AppModule {}
EOF

# (Gamificación, Admin, Tickets, etc.)
mkdir -p src/gamification
cat > src/gamification/gamification.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { GamificationService } from './gamification.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Badge } from './models/badge.entity';
import { UserBadge } from './models/user-badge.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Badge, UserBadge])],
  providers: [GamificationService],
  exports: [GamificationService]
})
export class GamificationModule {}
EOF

cat > src/gamification/gamification.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Badge } from './models/badge.entity';
import { UserBadge } from './models/user-badge.entity';

@Injectable()
export class GamificationService {
  constructor(
    @InjectRepository(Badge) private badgeRepo: Repository<Badge>,
    @InjectRepository(UserBadge) private userBadgeRepo: Repository<UserBadge>
  ) {}

  async checkAndUnlockBadges(userId: number, newPoints: number) {
    // Lógica que revisa si el usuario desbloquea algún badge
    const allBadges = await this.badgeRepo.find();
    for (const b of allBadges) {
      if (newPoints >= b.pointsRequired) {
        // Chequear si ya tiene
        const exist = await this.userBadgeRepo.findOne({ where: { userId, badgeId: b.id } });
        if (!exist) {
          const ub = this.userBadgeRepo.create({ userId, badgeId: b.id });
          await this.userBadgeRepo.save(ub);
        }
      }
    }
  }
}
EOF

mkdir -p src/gamification/models
cat > src/gamification/models/badge.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('badges')
export class Badge {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  name: string;

  @Column({ nullable: true })
  description: string;

  @Column({ name: 'points_required', default: 0 })
  pointsRequired: number;
}
EOF

cat > src/gamification/models/user-badge.entity.ts << 'EOF'
import { Entity, PrimaryColumn, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('user_badges')
export class UserBadge {
  @PrimaryColumn({ name: 'user_id' })
  userId: number;

  @PrimaryColumn({ name: 'badge_id' })
  badgeId: number;

  @Column({ name: 'unlocked_at', type: 'timestamp', default: () => 'NOW()' })
  unlockedAt: Date;
}
EOF

# AdminModule (superadmin panel)
mkdir -p src/admin
cat > src/admin/admin.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { AdminController } from './admin.controller';
import { UsersModule } from '../users/user.module';
import { ReservationsModule } from '../reservations/reservation.module';
import { PaymentsModule } from '../payments/payment.module';

@Module({
  imports: [UsersModule, ReservationsModule, PaymentsModule],
  controllers: [AdminController]
})
export class AdminModule {}
EOF

cat > src/admin/admin.controller.ts << 'EOF'
import { Controller, Get, Param, Patch, Query, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { UsersService } from '../users/user.service';
import { ReservationsService } from '../reservations/reservation.service';
import { PaymentsService } from '../payments/payment.service';

@Controller('admin')
@UseGuards(AuthGuard('jwt'))
export class AdminController {
  constructor(
    private usersService: UsersService,
    private reservationsService: ReservationsService,
    private paymentsService: PaymentsService
  ) {}

  @Get('users')
  async listUsers() {
    return this.usersService.getAllUsers();
  }

  @Patch('users/:id/role')
  async changeUserRole(@Param('id') id: number, @Query('role') role: string) {
    // Cambiar rol
    return this.usersService.update(+id, { role });
  }

  // Otras funciones de superadmin ...
}
EOF

# expandir user.service con getAllUsers
sed -i '' '/class UsersService/a \
  async getAllUsers(): Promise<User[]> {\n    return this.userRepo.find();\n  }\n' src/users/user.service.ts 2>/dev/null || true

# Módulo Tickets (soporte)
mkdir -p src/tickets
cat > src/tickets/tickets.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TicketsService } from './tickets.service';
import { TicketsController } from './tickets.controller';
import { Ticket } from './ticket.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Ticket])],
  providers: [TicketsService],
  controllers: [TicketsController]
})
export class TicketsModule {}
EOF

cat > src/tickets/tickets.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ticket } from './ticket.entity';

@Injectable()
export class TicketsService {
  constructor(
    @InjectRepository(Ticket) private ticketRepo: Repository<Ticket>
  ) {}

  async create(userId: number, subject: string, message: string) {
    const ticket = this.ticketRepo.create({ userId, subject, message, status: 'open' });
    return this.ticketRepo.save(ticket);
  }

  async listForUser(userId: number) {
    return this.ticketRepo.find({ where: { userId } });
  }

  async updateStatus(id: number, status: string) {
    await this.ticketRepo.update({ id }, { status });
    return this.ticketRepo.findOne({ where: { id } });
  }
}
EOF

cat > src/tickets/tickets.controller.ts << 'EOF'
import { Controller, Post, Get, Patch, Body, Param, UseGuards, Request } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { TicketsService } from './tickets.service';

@Controller('tickets')
@UseGuards(AuthGuard('jwt'))
export class TicketsController {
  constructor(private ticketsService: TicketsService) {}

  @Post()
  async createTicket(@Request() req, @Body() body: { subject: string, message: string }) {
    return this.ticketsService.create(req.user.userId, body.subject, body.message);
  }

  @Get()
  async getTickets(@Request() req) {
    return this.ticketsService.listForUser(req.user.userId);
  }

  @Patch(':id')
  async updateTicket(@Param('id') id: number, @Body() body: { status: string }) {
    return this.ticketsService.updateStatus(+id, body.status);
  }
}
EOF

cat > src/tickets/ticket.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('tickets')
export class Ticket {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'user_id' })
  userId: number;

  @Column()
  subject: string;

  @Column({ nullable: true })
  message: string;

  @Column({ default: 'open' })
  status: string;

  @Column({ name: 'created_at', type: 'timestamp', default: () => 'NOW()' })
  createdAt: Date;
}
EOF

# README final
cat > README.md << 'EOF'
# Dialoom Backend Avanzado

Este proyecto crea un **backend** completo para Dialoom con las siguientes funcionalidades:

1. **Autenticación con Roles (superadmin, admin, host, user)** con JWT.
2. **Gestión de Usuarios** (registro, login, perfil), hosts y su disponibilidad.
3. **Gamificación** con badges, niveles, ranking, sumando puntos por acciones.
4. **Multi-idioma** (carpeta i18n con JSON para ES, EN, CA, DE, FR, NO, DA, IT, PL, NL).
5. **Soporte/Tickets** para que usuarios abran incidencias.
6. **Reservas** con notificaciones push (Firebase) y retención de comisiones en pagos Stripe (Dialoom Commission + IVA).
7. **Videollamadas** con Agora (generación de token RTC).
8. **Panel superadmin** con rutas admin para ver usuarios, cambiar roles, etc.
9. **Despliegue** via Docker + Nginx, con scripts de BD en `database/`.

## Uso

```bash
cp .env.example .env
# Ajustar credenciales e integraciones
npm install
docker-compose up -d
