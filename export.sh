#!/usr/bin/env bash

#
# setup-dialoom-backend.sh
# Script para generar la estructura final del backend de Dialoom
# con todos los archivos y contenido que hemos ido construyendo.
#
# Uso:
#   chmod +x setup-dialoom-backend.sh
#   ./setup-dialoom-backend.sh
#
# Resultado:
#   Crea la carpeta ./dialoom-backend y todos los subdirectorios y ficheros.
#

echo "=== Creando estructura de carpetas para Dialoom Backend ==="

# 1) Crear la carpeta raíz del proyecto
mkdir -p dialoom-backend
cd dialoom-backend

# 2) Crear subcarpetas principales
mkdir -p src \
         src/config \
         src/common/guards \
         src/common/interceptors \
         src/common/decorators \
         src/modules \
         src/modules/auth/strategies \
         src/modules/auth/guards \
         src/modules/users/entities \
         src/modules/payments/entities \
         src/modules/gamification/entities \
         src/modules/notifications/channels \
         src/modules/notifications/entities \
         src/modules/support/entities \
         src/modules/admin/entities \
         test \
         locales

# 3) Creamos Dockerfile, docker-compose, .env.example, package.json, tsconfig.json
cat << 'EOF' > Dockerfile
# Dockerfile: Construye la imagen para el backend de Dialoom (versión final optimizada)

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
EOF

cat << 'EOF' > docker-compose.yml
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
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    container_name: dialoom-redis
    restart: unless-stopped

volumes:
  postgres_data:
EOF

cat << 'EOF' > .env.example
# Ejemplo de variables de entorno para Dialoom

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

# OAuth credentials (ejemplo Google)
GOOGLE_CLIENT_ID=xxx.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=xxx
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback

# Facebook, Microsoft, Apple...
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

# Twilio
TWILIO_ACCOUNT_SID=xxx
TWILIO_AUTH_TOKEN=xxx
TWILIO_SMS_FROM=+123456789
TWILIO_WHATSAPP_FROM=whatsapp:+14155238886

# Commission & VAT
DEFAULT_COMMISSION_RATE=0.10
DEFAULT_VAT_RATE=0.21

# Retention settings (días)
PAYMENT_RETENTION_DAYS=7
EOF

cat << 'EOF' > package.json
{
  "name": "dialoom-backend",
  "version": "1.0.0",
  "description": "Backend NestJS for Dialoom platform",
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
    "agora-access-token": "^2.0.0",
    "bcrypt": "^5.1.0",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.1",
    "firebase-admin": "^11.0.0",
    "ioredis": "^5.2.0",
    "passport": "^0.6.0",
    "passport-apple": "^1.2.0",
    "passport-facebook": "^3.0.0",
    "passport-google-oauth20": "^2.0.0",
    "passport-jwt": "^4.0.0",
    "passport-microsoft": "^1.0.0",
    "redis": "^3.1.2",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.0.0",
    "stripe": "^11.0.0",
    "twilio": "^3.84.0",
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
    "@types/passport-google-oauth20": "^2.1.10",
    "@types/passport-jwt": "^3.0.6",
    "@types/passport-microsoft": "^1.0.0",
    "@types/redis": "^2.8.33",
    "@types/socket.io": "^3.0.2",
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
EOF

cat << 'EOF' > tsconfig.json
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "ES2021",
    "lib": ["ES2021", "DOM"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "test"]
}
EOF

# 4) Creamos los archivos principales de NestJS: main.ts, app.module.ts, app.service.ts, app.controller.ts
cat << 'EOF' > src/main.ts
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import helmet from 'helmet';
import { json, urlencoded } from 'express';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Seguridad HTTP
  app.use(helmet());
  // Aceptar cuerpos de cierto tamaño
  app.use(json({ limit: '10mb' }));
  app.use(urlencoded({ extended: true, limit: '10mb' }));

  // Versionado global (opcional)
  // app.setGlobalPrefix('api/v1');
  // O bien:
  // import { VersioningType } from '@nestjs/common';
  // app.enableVersioning({
  //   type: VersioningType.URI,
  //   defaultVersion: '1'
  // });

  // Validación de DTOs global
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true
  }));

  app.enableCors({ origin: '*' });
  await app.listen(3000);
  console.log('Dialoom backend running on port 3000');
}
bootstrap();
EOF

cat << 'EOF' > src/app.module.ts
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { GamificationModule } from './modules/gamification/gamification.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { SupportModule } from './modules/support/support.module';
import { AdminModule } from './modules/admin/admin.module';
// Ejemplo: import { ThrottlerModule } from '@nestjs/throttler';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    // Ejemplo Throttler:
    // ThrottlerModule.forRoot({
    //   ttl: 60,
    //   limit: 100,
    // }),
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
        synchronize: false, // En producción usar migraciones
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
  controllers: [],
  providers: [],
})
export class AppModule {}
EOF

cat << 'EOF' > src/app.service.ts
import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello Dialoom!';
  }
}
EOF

cat << 'EOF' > src/app.controller.ts
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
EOF

# === COMMON FOLDERS ===
# Guards: roles.guard.ts / jwt-auth.guard.ts
cat << 'EOF' > src/common/guards/roles.guard.ts
import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { UserRole } from '../../modules/users/entities/user.entity';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.get<UserRole[]>('roles', context.getHandler());
    if (!requiredRoles || requiredRoles.length === 0) {
      return true; // no se requiere rol específico
    }
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    if (!user) {
      return false;
    }
    const hasRole = requiredRoles.includes(user.role);
    if (!hasRole) {
      throw new ForbiddenException('No tienes permiso para acceder a este recurso');
    }
    return true;
  }
}
EOF

cat << 'EOF' > src/common/guards/jwt-auth.guard.ts
import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
EOF

# Decorator roles.decorator.ts
cat << 'EOF' > src/common/decorators/roles.decorator.ts
import { SetMetadata } from '@nestjs/common';
import { UserRole } from '../../modules/users/entities/user.entity';

export const Roles = (...roles: UserRole[]) => SetMetadata('roles', roles);
EOF

# Interceptor de logging (opcional)
cat << 'EOF' > src/common/interceptors/logging.interceptor.ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable, tap } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    const { method, originalUrl } = request;
    const userId = user ? user.id : 'Anonymous';
    const logMessage = \`User \${userId} -> [\${method}] \${originalUrl}\`;
    console.log(logMessage);

    return next.handle().pipe(
      tap(() => console.log(\`Completed: \${logMessage}\`))
    );
  }
}
EOF

# === AUTH MODULE ===
cat << 'EOF' > src/modules/auth/auth.module.ts
import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from '../users/users.module';
import { GoogleStrategy } from './strategies/google.strategy';
import { FacebookStrategy } from './strategies/facebook.strategy';
import { MicrosoftStrategy } from './strategies/microsoft.strategy';
import { AppleStrategy } from './strategies/apple.strategy';
import { JwtStrategy } from './strategies/jwt.strategy';

@Module({
  imports: [
    UsersModule,
    PassportModule.register({ session: false }),
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('JWT_SECRET'),
        signOptions: { expiresIn: '2h' }
      })
    })
  ],
  providers: [
    AuthService,
    GoogleStrategy,
    FacebookStrategy,
    MicrosoftStrategy,
    AppleStrategy,
    JwtStrategy
  ],
  controllers: [AuthController],
  exports: [AuthService]
})
export class AuthModule {}
EOF

cat << 'EOF' > src/modules/auth/auth.service.ts
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { User, UserRole } from '../users/entities/user.entity';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async validateOAuthLogin(provider: string, oauthProfile: any): Promise<User> {
    // Se espera que oauthProfile contenga email y un id unico
    const email = oauthProfile.email;
    const name = oauthProfile.name || oauthProfile.displayName;
    if (!email) {
      throw new UnauthorizedException('No email provided by OAuth profile');
    }
    // Buscar usuario
    let user = await this.usersService.findByEmail(email);
    if (!user) {
      // Crear usuario
      user = await this.usersService.createOAuthUser(name, email, UserRole.USER);
    }
    return user;
  }

  generateJwt(user: User): string {
    const payload = { sub: user.id, role: user.role, email: user.email };
    return this.jwtService.sign(payload);
  }

  // Verificar 2FA (ejemplo, supón que tenemos guardado secret TOTP en user.twoFactorSecret)
  verify2FA(user: User, code: string): boolean {
    // Implementar la verificación real (ej: speakeasy.totp.verify...)
    if (!user.twoFactorEnabled) return true; // no requiere 2FA
    // TODO: Lógica real
    return true;
  }
}
EOF

cat << 'EOF' > src/modules/auth/auth.controller.ts
import { Controller, Get, Req, Res, UseGuards } from '@nestjs/common';
import { Response } from 'express';
import { AuthService } from './auth.service';
import { GoogleAuthGuard, FacebookAuthGuard, MicrosoftAuthGuard, AppleAuthGuard } from './guards/oauth.guards';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Get('google')
  @UseGuards(GoogleAuthGuard)
  async googleAuth() {
    // Inicia el flujo OAuth con Google
  }

  @Get('google/redirect')
  @UseGuards(GoogleAuthGuard)
  async googleAuthRedirect(@Req() req: any, @Res() res: Response) {
    const user = req.user;
    const jwt = this.authService.generateJwt(user);
    // Redirigir al frontend con el JWT en query param o cookie
    return res.redirect(\`dialoom://auth?token=\${jwt}\`);
  }

  @Get('facebook')
  @UseGuards(FacebookAuthGuard)
  async facebookAuth() {}

  @Get('facebook/redirect')
  @UseGuards(FacebookAuthGuard)
  async facebookAuthRedirect(@Req() req: any, @Res() res: Response) {
    const user = req.user;
    const jwt = this.authService.generateJwt(user);
    return res.redirect(\`dialoom://auth?token=\${jwt}\`);
  }

  @Get('microsoft')
  @UseGuards(MicrosoftAuthGuard)
  async microsoftAuth() {}

  @Get('microsoft/redirect')
  @UseGuards(MicrosoftAuthGuard)
  async microsoftAuthRedirect(@Req() req: any, @Res() res: Response) {
    const user = req.user;
    const jwt = this.authService.generateJwt(user);
    return res.redirect(\`dialoom://auth?token=\${jwt}\`);
  }

  @Get('apple')
  @UseGuards(AppleAuthGuard)
  async appleAuth() {}

  @Get('apple/redirect')
  @UseGuards(AppleAuthGuard)
  async appleAuthRedirect(@Req() req: any, @Res() res: Response) {
    const user = req.user;
    const jwt = this.authService.generateJwt(user);
    return res.redirect(\`dialoom://auth?token=\${jwt}\`);
  }
}
EOF

# === GUARDS para OAuth (strategies) ===
cat << 'EOF' > src/modules/auth/guards/oauth.guards.ts
import { AuthGuard } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';

@Injectable()
export class GoogleAuthGuard extends AuthGuard('google') {}

@Injectable()
export class FacebookAuthGuard extends AuthGuard('facebook') {}

@Injectable()
export class MicrosoftAuthGuard extends AuthGuard('microsoft') {}

@Injectable()
export class AppleAuthGuard extends AuthGuard('apple') {}
EOF

# === JWT Strategy
cat << 'EOF' > src/modules/auth/strategies/jwt.strategy.ts
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(config: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get<string>('JWT_SECRET'),
    });
  }

  async validate(payload: any) {
    // Retornar un objeto que se adjuntará a req.user
    return { id: payload.sub, email: payload.email, role: payload.role };
  }
}
EOF

# === Google Strategy
cat << 'EOF' > src/modules/auth/strategies/google.strategy.ts
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy, VerifyCallback } from 'passport-google-oauth20';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

@Injectable()
export class GoogleStrategy extends PassportStrategy(Strategy, 'google') {
  constructor(private configService: ConfigService, private authService: AuthService) {
    super({
      clientID: configService.get<string>('GOOGLE_CLIENT_ID'),
      clientSecret: configService.get<string>('GOOGLE_CLIENT_SECRET'),
      callbackURL: configService.get<string>('GOOGLE_CALLBACK_URL') || 'http://localhost:3000/auth/google/redirect',
      scope: ['email', 'profile'],
    });
  }

  async validate(accessToken: string, refreshToken: string, profile: any, done: VerifyCallback): Promise<any> {
    const email = profile.emails[0].value;
    const name = profile.displayName;
    const oauthProfile = { email, name, displayName: profile.displayName };
    const user = await this.authService.validateOAuthLogin('google', oauthProfile);
    return done(null, user);
  }
}
EOF

# === Facebook Strategy
cat << 'EOF' > src/modules/auth/strategies/facebook.strategy.ts
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-facebook';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

@Injectable()
export class FacebookStrategy extends PassportStrategy(Strategy, 'facebook') {
  constructor(private configService: ConfigService, private authService: AuthService) {
    super({
      clientID: configService.get<string>('FACEBOOK_APP_ID'),
      clientSecret: configService.get<string>('FACEBOOK_APP_SECRET'),
      callbackURL: 'http://localhost:3000/auth/facebook/redirect',
      profileFields: ['id', 'emails', 'name']
    });
  }

  async validate(accessToken: string, refreshToken: string, profile: any) {
    const { name, emails } = profile;
    const email = emails && emails[0]?.value;
    const fullName = name?.givenName + ' ' + name?.familyName;
    const oauthProfile = { name: fullName, email };
    const user = await this.authService.validateOAuthLogin('facebook', oauthProfile);
    return user;
  }
}
EOF

# === Microsoft Strategy
cat << 'EOF' > src/modules/auth/strategies/microsoft.strategy.ts
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-microsoft';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

@Injectable()
export class MicrosoftStrategy extends PassportStrategy(Strategy, 'microsoft') {
  constructor(config: ConfigService, private authService: AuthService) {
    super({
      clientID: config.get<string>('MICROSOFT_CLIENT_ID'),
      clientSecret: config.get<string>('MICROSOFT_CLIENT_SECRET'),
      callbackURL: 'http://localhost:3000/auth/microsoft/redirect',
      scope: ['user.read']
    });
  }

  async validate(accessToken: string, refreshToken: string, profile: any) {
    const email = profile.emails && profile.emails[0]?.value;
    const name = profile.displayName;
    const oauthProfile = { email, name };
    const user = await this.authService.validateOAuthLogin('microsoft', oauthProfile);
    return user;
  }
}
EOF

# === Apple Strategy
cat << 'EOF' > src/modules/auth/strategies/apple.strategy.ts
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import AppleStrategyPassport from 'passport-apple';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

const AppleStrategy = AppleStrategyPassport.Strategy;

@Injectable()
export class AppleStrategy extends PassportStrategy(AppleStrategy, 'apple') {
  constructor(config: ConfigService, private authService: AuthService) {
    super({
      clientID: config.get<string>('APPLE_CLIENT_ID'),
      teamID: config.get<string>('APPLE_TEAM_ID'),
      keyID: config.get<string>('APPLE_KEY_ID'),
      privateKeyString: config.get<string>('APPLE_PRIVATE_KEY')?.replace(/\\n/g, '\n'),
      callbackURL: 'http://localhost:3000/auth/apple/redirect',
      scope: ['name', 'email'],
    });
  }

  async validate(accessToken: string, refreshToken: string, idToken: any, profile: any) {
    // Se valida la firma del idToken si es necesario
    const email = profile.email || profile._json.email;
    const name = profile.name?.firstName || profile.displayName || 'AppleUser';
    const oauthProfile = { email, name };
    const user = await this.authService.validateOAuthLogin('apple', oauthProfile);
    return user;
  }
}
EOF

# === USERS MODULE ===
cat << 'EOF' > src/modules/users/entities/user.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

export enum UserRole {
  USER = 'user',
  HOST = 'host',
  ADMIN = 'admin',
  SUPERADMIN = 'superadmin'
}

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 100 })
  name: string;

  @Column({ unique: true, length: 150 })
  email: string;

  @Column({ type: 'enum', enum: UserRole, default: UserRole.USER })
  role: UserRole;

  @Column({ default: false })
  isVerified: boolean;  // verificación de identidad completada?

  @Column({ default: false })
  twoFactorEnabled: boolean;

  @Column({ nullable: true })
  twoFactorSecret: string;

  @Column({ nullable: true })
  stripeAccountId?: string;  // ID de cuenta Stripe Connect si es host

  // Gamificación
  @Column({ default: 0 })
  points: number;

  @Column({ default: 1 })
  level: number;

  @CreateDateColumn()
  createdAt: Date;
}
EOF

cat << 'EOF' > src/modules/users/users.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  providers: [UsersService],
  controllers: [UsersController],
  exports: [UsersService]
})
export class UsersModule {}
EOF

cat << 'EOF' > src/modules/users/users.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from './entities/user.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private usersRepo: Repository<User>,
  ) {}

  async findById(id: number): Promise<User | undefined> {
    return this.usersRepo.findOne({ where: { id } });
  }

  async findByEmail(email: string): Promise<User | undefined> {
    return this.usersRepo.findOne({ where: { email } });
  }

  async createOAuthUser(name: string, email: string, role: UserRole = UserRole.USER): Promise<User> {
    const user = this.usersRepo.create({ name, email, role });
    return await this.usersRepo.save(user);
  }

  async createLocalUser(name: string, email: string, password: string): Promise<User> {
    const hashed = await bcrypt.hash(password, 10);
    const user = this.usersRepo.create({ name, email });
    // user.passwordHash = hashed; // si se maneja pass local
    return await this.usersRepo.save(user);
  }

  async updateProfile(id: number, data: Partial<User>): Promise<User> {
    await this.usersRepo.update(id, data);
    return this.findById(id);
  }

  async verifyUser(id: number): Promise<void> {
    await this.usersRepo.update(id, { isVerified: true });
  }
}
EOF

cat << 'EOF' > src/modules/users/users.controller.ts
import { Controller, Get, Put, Body, Req, UseGuards, Patch } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from './entities/user.entity';

@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get('me')
  async getProfile(@Req() req: any) {
    const userId = req.user.id;
    return this.usersService.findById(userId);
  }

  @Put('me')
  async updateProfile(@Req() req: any, @Body() updateDto: any) {
    const userId = req.user.id;
    return this.usersService.updateProfile(userId, updateDto);
  }

  // Solo un admin o superadmin puede verificar a un usuario
  @Patch(':id/verify')
  @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  async verifyUser(@Req() req: any) {
    const userId = parseInt(req.params.id, 10);
    await this.usersService.verifyUser(userId);
    return { message: 'Usuario verificado' };
  }
}
EOF

# === PAYMENTS MODULE ===
cat << 'EOF' > src/modules/payments/entities/transaction.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum TransactionStatus {
  HOLD = 'hold',
  RELEASED = 'released',
  PAID_OUT = 'paid_out',
  REFUNDED = 'refunded'
}

@Entity()
export class Transaction {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  amount: number;  // importe total en centavos

  @Column({ default: 'EUR' })
  currency: string;

  @Column({ type: 'float' })
  commissionRate: number;  // ej 0.10 para 10%

  @Column({ type: 'float' })
  vatRate: number;  // ej 0.21 para 21%

  @Column({ default: 0 })
  feeAmount: number; // comision + IVA

  @Column()
  hostId: number;   // ID del host que recibirá la parte neta

  @Column({ type: 'enum', enum: TransactionStatus, default: TransactionStatus.HOLD })
  status: TransactionStatus;

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  user: User;   // usuario que pagó
}
EOF

cat << 'EOF' > src/modules/payments/payments.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Transaction } from './entities/transaction.entity';
import { PaymentsService } from './payments.service';
import { PaymentsController } from './payments.controller';
import { StripeService } from './stripe.service';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([Transaction]), UsersModule],
  providers: [PaymentsService, StripeService],
  controllers: [PaymentsController],
  exports: [PaymentsService]
})
export class PaymentsModule {}
EOF

cat << 'EOF' > src/modules/payments/payments.service.ts
import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThanOrEqual } from 'typeorm';
import { StripeService } from './stripe.service';
import { Transaction, TransactionStatus } from './entities/transaction.entity';
import { UsersService } from '../users/users.service';
import { User } from '../users/entities/user.entity';
import * as dayjs from 'dayjs';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class PaymentsService {
  private retentionDays: number;
  private defaultCommission: number;
  private defaultVAT: number;

  constructor(
    private stripeService: StripeService,
    private usersService: UsersService,
    @InjectRepository(Transaction) private txRepo: Repository<Transaction>,
    private config: ConfigService
  ) {
    this.retentionDays = this.config.get<number>('PAYMENT_RETENTION_DAYS') || 7;
    this.defaultCommission = this.config.get<number>('DEFAULT_COMMISSION_RATE') || 0.10;
    this.defaultVAT = this.config.get<number>('DEFAULT_VAT_RATE') || 0.21;
  }

  async createCharge(clientId: number, hostId: number, amount: number, currency: string = 'EUR') {
    const host: User = await this.usersService.findById(hostId);
    if (!host) {
      throw new BadRequestException('Host no disponible');
    }
    // Calcular comision + IVA
    const commission = amount * this.defaultCommission;
    const vat = commission * this.defaultVAT;
    const totalFee = commission + vat;

    // Crear PaymentIntent en Stripe
    const paymentIntent = await this.stripeService.createPaymentIntent(
      amount, currency, host.stripeAccountId, Math.round(commission), Math.round(vat)
    );

    const now = new Date();
    const availableOn = dayjs(now).add(this.retentionDays, 'day').toDate();

    const tx = this.txRepo.create({
      amount,
      currency,
      commissionRate: this.defaultCommission,
      vatRate: this.defaultVAT,
      feeAmount: totalFee,
      hostId: hostId,
      status: TransactionStatus.HOLD,
      user: { id: clientId } as User
    });
    await this.txRepo.save(tx);

    return { paymentIntentClientSecret: paymentIntent.client_secret };
  }

  async processPayouts(): Promise<void> {
    const now = new Date();
    const dueTxs = await this.txRepo.find({
      where: {
        status: TransactionStatus.HOLD,
        createdAt: LessThanOrEqual(dayjs(now).subtract(this.retentionDays, 'day').toDate())
      }
    });
    for (const tx of dueTxs) {
      // Transferir la parte neta al host
      tx.status = TransactionStatus.PAID_OUT;
      await this.txRepo.save(tx);
      // TODO: Llamar a stripeService.createTransfer(...) si no se hizo automatic
    }
  }
}
EOF

cat << 'EOF' > src/modules/payments/payments.controller.ts
import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('payments')
export class PaymentsController {
  constructor(private paymentsService: PaymentsService) {}

  @Post('charge')
  @UseGuards(JwtAuthGuard)
  async chargeHost(@Req() req: any, @Body() body: { hostId: number, amount: number }) {
    const clientId = req.user.id;
    const { hostId, amount } = body;
    return this.paymentsService.createCharge(clientId, hostId, amount);
  }
}
EOF

cat << 'EOF' > src/modules/payments/stripe.service.ts
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';

@Injectable()
export class StripeService {
  private stripe: Stripe;
  constructor(private config: ConfigService) {
    this.stripe = new Stripe(this.config.get<string>('STRIPE_SECRET_KEY'), {
      apiVersion: '2022-11-15'
    });
  }

  async createPaymentIntent(amount: number, currency: string, hostStripeAccount: string, commission: number, vat: number) {
    const applicationFee = commission + vat; // en centavos si se requiere
    return this.stripe.paymentIntents.create({
      amount: Math.round(amount),
      currency,
      payment_method_types: ['card'],
      transfer_data: {
        destination: hostStripeAccount,
      },
      application_fee_amount: Math.round(applicationFee)
    });
  }

  async createTransfer(amount: number, currency: string, destination: string) {
    return this.stripe.transfers.create({
      amount: Math.round(amount),
      currency,
      destination
    });
  }
}
EOF

# === GAMIFICATION ===
cat << 'EOF' > src/modules/gamification/entities/achievement.entity.ts
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Achievement {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  name: string;

  @Column()
  description: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ default: 0 })
  points: number;
}
EOF

cat << 'EOF' > src/modules/gamification/entities/level.entity.ts
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Level {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  levelNumber: number;

  @Column()
  requiredPoints: number;
}
EOF

cat << 'EOF' > src/modules/gamification/entities/user-achievement.entity.ts
import { Entity, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Achievement } from './achievement.entity';

@Entity()
export class UserAchievement {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, user => user.id, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Achievement, { onDelete: 'CASCADE' })
  achievement: Achievement;

  @CreateDateColumn()
  achievedAt: Date;
}
EOF

cat << 'EOF' > src/modules/gamification/gamification.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Achievement } from './entities/achievement.entity';
import { Level } from './entities/level.entity';
import { UserAchievement } from './entities/user-achievement.entity';
import { GamificationService } from './gamification.service';
import { GamificationController } from './gamification.controller';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Achievement, Level, UserAchievement]),
    UsersModule
  ],
  controllers: [GamificationController],
  providers: [GamificationService],
  exports: [GamificationService]
})
export class GamificationModule {}
EOF

cat << 'EOF' > src/modules/gamification/gamification.service.ts
import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Achievement } from './entities/achievement.entity';
import { Level } from './entities/level.entity';
import { UserAchievement } from './entities/user-achievement.entity';
import { UsersService } from '../users/users.service';
import { User } from '../users/entities/user.entity';

@Injectable()
export class GamificationService {
  constructor(
    @InjectRepository(Achievement) private achieveRepo: Repository<Achievement>,
    @InjectRepository(Level) private levelRepo: Repository<Level>,
    @InjectRepository(UserAchievement) private userAchRepo: Repository<UserAchievement>,
    private usersService: UsersService,
  ) {}

  async awardAchievement(userId: number, achievementId: number) {
    const user = await this.usersService.findById(userId);
    const achievement = await this.achieveRepo.findOne({ where: { id: achievementId } });
    if (!user || !achievement) return;
    // Verificar si ya existe
    const exists = await this.userAchRepo.findOne({ where: { user: { id: userId }, achievement: { id: achievementId } } });
    if (!exists) {
      const ua = this.userAchRepo.create({ user, achievement });
      await this.userAchRepo.save(ua);
      // Sumar puntos si achievement.points > 0
      if (achievement.points > 0) {
        await this.addPoints(userId, achievement.points);
      }
    }
  }

  async addPoints(userId: number, points: number) {
    const user = await this.usersService.findById(userId);
    if (!user) return;
    user.points += points;
    // Check nivel
    const levels = await this.levelRepo.find();
    levels.sort((a,b) => a.requiredPoints - b.requiredPoints);
    let newLevel = user.level;
    for (const lvl of levels) {
      if (user.points >= lvl.requiredPoints && lvl.levelNumber > newLevel) {
        newLevel = lvl.levelNumber;
      }
    }
    user.level = newLevel;
    await this.usersService.updateProfile(user.id, { points: user.points, level: user.level });
  }

  // CRUD básicos para logros, niveles
  async createAchievement(name: string, description: string, points: number = 0) {
    const achieve = this.achieveRepo.create({ name, description, points });
    return this.achieveRepo.save(achieve);
  }

  async createLevel(levelNumber: number, requiredPoints: number) {
    const lvl = this.levelRepo.create({ levelNumber, requiredPoints });
    return this.levelRepo.save(lvl);
  }
}
EOF

cat << 'EOF' > src/modules/gamification/gamification.controller.ts
import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { GamificationService } from './gamification.service';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from '../users/entities/user.entity';

@Controller('gamification')
@UseGuards(RolesGuard)
export class GamificationController {
  constructor(private gamificationService: GamificationService) {}

  @Post('achievements')
  @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  async createAchievement(@Body() body: { name: string, description: string, points?: number }) {
    const { name, description, points } = body;
    return this.gamificationService.createAchievement(name, description, points || 0);
  }

  @Post('levels')
  @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  async createLevel(@Body() body: { levelNumber: number, requiredPoints: number }) {
    const { levelNumber, requiredPoints } = body;
    return this.gamificationService.createLevel(levelNumber, requiredPoints);
  }
}
EOF

# === NOTIFICATIONS ===
cat << 'EOF' > src/modules/notifications/notifications.module.ts
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
EOF

cat << 'EOF' > src/modules/notifications/notifications.service.ts
import { Injectable } from '@nestjs/common';
import { FcmService } from './channels/fcm.service';
import { SendGridService } from './channels/sendgrid.service';
import { TwilioService } from './channels/twilio.service';

@Injectable()
export class NotificationsService {
  constructor(
    private fcmService: FcmService,
    private sendGridService: SendGridService,
    private twilioService: TwilioService
  ) {}

  async sendPush(token: string, title: string, body: string, data?: any) {
    return this.fcmService.sendPushNotification(token, title, body, data);
  }

  async sendEmail(to: string, subject: string, htmlContent: string) {
    return this.sendGridService.sendEmail(to, subject, htmlContent);
  }

  async sendSMS(toNumber: string, message: string) {
    return this.twilioService.sendSms(toNumber, message);
  }

  async sendWhatsApp(toNumber: string, message: string) {
    return this.twilioService.sendWhatsappMessage(toNumber, message);
  }
}
EOF

cat << 'EOF' > src/modules/notifications/channels/fcm.service.ts
import { Injectable } from '@nestjs/common';
import * as admin from 'firebase-admin';

@Injectable()
export class FcmService {
  constructor() {
    // Se asume que en el AppModule se inicializó firebase-admin
  }

  async sendPushNotification(deviceToken: string, title: string, body: string, data?: any) {
    const message: admin.messaging.Message = {
      token: deviceToken,
      notification: { title, body },
      data: data || {},
      android: { priority: 'high' }
    };
    return admin.messaging().send(message);
  }
}
EOF

cat << 'EOF' > src/modules/notifications/channels/sendgrid.service.ts
import { Injectable } from '@nestjs/common';
import * as sgMail from '@sendgrid/mail';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class SendGridService {
  constructor(private config: ConfigService) {
    sgMail.setApiKey(this.config.get<string>('SENDGRID_API_KEY') || '');
  }

  async sendEmail(to: string, subject: string, htmlContent: string) {
    const msg = {
      to,
      from: this.config.get<string>('SENDGRID_FROM_EMAIL') || 'no-reply@dialoom.com',
      subject,
      html: htmlContent,
    };
    await sgMail.send(msg);
  }
}
EOF

cat << 'EOF' > src/modules/notifications/channels/twilio.service.ts
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import twilio from 'twilio';

@Injectable()
export class TwilioService {
  private client: twilio.Twilio;

  constructor(private config: ConfigService) {
    const accountSid = config.get<string>('TWILIO_ACCOUNT_SID');
    const authToken = config.get<string>('TWILIO_AUTH_TOKEN');
    this.client = twilio(accountSid, authToken);
  }

  async sendSms(toNumber: string, message: string) {
    const fromNumber = this.config.get<string>('TWILIO_SMS_FROM');
    return this.client.messages.create({
      body: message,
      from: fromNumber,
      to: toNumber
    });
  }

  async sendWhatsappMessage(toNumber: string, message: string) {
    const fromWhatsapp = this.config.get<string>('TWILIO_WHATSAPP_FROM');
    return this.client.messages.create({
      body: message,
      from: fromWhatsapp,
      to: \`whatsapp:\${toNumber}\`
    });
  }
}
EOF

# === SUPPORT (tickets, chat) ===
cat << 'EOF' > src/modules/support/support.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SupportService } from './support.service';
import { SupportController } from './support.controller';
import { Ticket } from './entities/ticket.entity';
import { Message } from './entities/message.entity';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([Ticket, Message]), UsersModule],
  providers: [SupportService],
  controllers: [SupportController],
  exports: [SupportService]
})
export class SupportModule {}
EOF

cat << 'EOF' > src/modules/support/entities/ticket.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, OneToMany } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Message } from './message.entity';

export enum TicketStatus {
  OPEN = 'open',
  CLOSED = 'closed'
}

@Entity()
export class Ticket {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 200 })
  subject: string;

  @Column({ type: 'enum', enum: TicketStatus, default: TicketStatus.OPEN })
  status: TicketStatus;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  user: User; // usuario que creó el ticket

  @CreateDateColumn()
  createdAt: Date;

  @OneToMany(() => Message, (message) => message.ticket)
  messages: Message[];
}
EOF

cat << 'EOF' > src/modules/support/entities/message.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { Ticket } from './ticket.entity';
import { User } from '../../users/entities/user.entity';

@Entity()
export class Message {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Ticket, ticket => ticket.messages, { onDelete: 'CASCADE' })
  ticket: Ticket;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  sender: User;

  @Column()
  content: string;

  @CreateDateColumn()
  timestamp: Date;
}
EOF

cat << 'EOF' > src/modules/support/support.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ticket, TicketStatus } from './entities/ticket.entity';
import { Message } from './entities/message.entity';
import { UsersService } from '../users/users.service';

@Injectable()
export class SupportService {
  constructor(
    @InjectRepository(Ticket) private ticketRepo: Repository<Ticket>,
    @InjectRepository(Message) private messageRepo: Repository<Message>,
    private usersService: UsersService,
  ) {}

  async createTicket(userId: number, subject: string): Promise<Ticket> {
    const user = { id: userId } as any;
    const ticket = this.ticketRepo.create({ user, subject });
    return this.ticketRepo.save(ticket);
  }

  async postMessage(ticketId: number, senderId: number, content: string): Promise<Message> {
    const ticket = await this.ticketRepo.findOne({ where: { id: ticketId } });
    const sender = await this.usersService.findById(senderId);
    const message = this.messageRepo.create({ ticket, sender, content });
    return this.messageRepo.save(message);
  }

  async closeTicket(ticketId: number) {
    await this.ticketRepo.update(ticketId, { status: TicketStatus.CLOSED });
  }

  async listTickets(): Promise<Ticket[]> {
    return this.ticketRepo.find({ relations: ['user'] });
  }

  async getMessages(ticketId: number): Promise<Message[]> {
    return this.messageRepo.find({ where: { ticket: { id: ticketId } }, relations: ['sender'] });
  }
}
EOF

cat << 'EOF' > src/modules/support/support.controller.ts
import { Controller, Post, Get, Patch, Param, Body, Req, UseGuards } from '@nestjs/common';
import { SupportService } from './support.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('support')
@UseGuards(JwtAuthGuard)
export class SupportController {
  constructor(private supportService: SupportService) {}

  @Post('tickets')
  async createTicket(@Req() req: any, @Body() body: { subject: string }) {
    const userId = req.user.id;
    return this.supportService.createTicket(userId, body.subject);
  }

  @Get('tickets/:id/messages')
  async getTicketMessages(@Param('id') ticketId: string) {
    return this.supportService.getMessages(Number(ticketId));
  }

  @Patch('tickets/:id/close')
  async closeTicket(@Param('id') ticketId: string) {
    await this.supportService.closeTicket(Number(ticketId));
    return { status: 'closed' };
  }

  @Get('tickets')
  async listAllTickets() {
    return this.supportService.listTickets();
  }
}
EOF

# === ADMIN MODULE ===
cat << 'EOF' > src/modules/admin/entities/setting.entity.ts
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Setting {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  key: string;

  @Column()
  value: string;
}
EOF

cat << 'EOF' > src/modules/admin/entities/log.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class Log {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  action: string;

  @Column()
  performedBy: string;

  @CreateDateColumn()
  timestamp: Date;
}
EOF

cat << 'EOF' > src/modules/admin/admin.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminService } from './admin.service';
import { AdminController } from './admin.controller';
import { Setting } from './entities/setting.entity';
import { Log } from './entities/log.entity';
import { UsersModule } from '../users/users.module';
import { PaymentsModule } from '../payments/payments.module';
import { GamificationModule } from '../gamification/gamification.module';
import { SupportModule } from '../support/support.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Setting, Log]),
    UsersModule,
    PaymentsModule,
    GamificationModule,
    SupportModule
  ],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
EOF

cat << 'EOF' > src/modules/admin/admin.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Setting } from './entities/setting.entity';
import { Log } from './entities/log.entity';
import { UsersService } from '../users/users.service';
import { PaymentsService } from '../payments/payments.service';
import { GamificationService } from '../gamification/gamification.service';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(Setting) private settingsRepo: Repository<Setting>,
    @InjectRepository(Log) private logRepo: Repository<Log>,
    private usersService: UsersService,
    private paymentsService: PaymentsService,
    private gamificationService: GamificationService,
  ) {}

  async getSetting(key: string): Promise<Setting> {
    return this.settingsRepo.findOne({ where: { key } });
  }

  async updateSetting(key: string, value: string): Promise<Setting> {
    let setting = await this.settingsRepo.findOne({ where: { key } });
    if (!setting) {
      setting = this.settingsRepo.create({ key, value });
    } else {
      setting.value = value;
    }
    const saved = await this.settingsRepo.save(setting);
    await this.logRepo.save({ action: \`UPDATE_SETTING:\${key}=\${value}\`, performedBy: 'admin' });
    return saved;
  }

  async banUser(userId: number) {
    // Cambia el rol o marca al usuario inactivo
    await this.usersService.updateProfile(userId, { role: 'banned' } as any);
    await this.logRepo.save({ action: \`BAN_USER:\${userId}\`, performedBy: 'admin' });
  }
}
EOF

cat << 'EOF' > src/modules/admin/admin.controller.ts
import { Controller, Get, Put, Param, Body, UseGuards } from '@nestjs/common';
import { AdminService } from './admin.service';
import { SupportService } from '../support/support.service';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from '../users/entities/user.entity';

@UseGuards(RolesGuard)
@Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
@Controller('admin')
export class AdminController {
  constructor(
    private adminService: AdminService,
    private supportService: SupportService
  ) {}

  @Get('support/tickets')
  async listSupportTickets() {
    return this.supportService.listTickets();
  }

  @Put('users/ban/:id')
  async banUser(@Param('id') userId: string) {
    await this.adminService.banUser(Number(userId));
    return { status: 'banned' };
  }

  @Get('settings/:key')
  async getSetting(@Param('key') key: string) {
    return this.adminService.getSetting(key);
  }

  @Put('settings/:key')
  async updateSetting(@Param('key') key: string, @Body() body: { value: string }) {
    const { value } = body;
    return this.adminService.updateSetting(key, value);
  }
}
EOF

# === LOCALES (i18n) ===
cat << 'EOF' > locales/es.json
{
  "general": {
    "hello": "Hola en Español"
  }
}
EOF

cat << 'EOF' > locales/en.json
{
  "general": {
    "hello": "Hello in English"
  }
}
EOF

# ... y así podrías añadir catalán, alemán, francés, noruego, danés, italiano, polaco y holandés,
# pero por brevedad se deja solo es.json y en.json de muestra
# (puedes añadir aquí el resto de ficheros con las traducciones finales).

# 12) Creamos un test de ejemplo en test/
cat << 'EOF' > test/app.e2e-spec.ts
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
EOF

# Final:
echo "=== Estructura de Dialoom Backend generada con éxito ==="
echo "Puedes ingresar a la carpeta dialoom-backend y revisar los archivos."
echo "Recuerda revisar y editar las variables en .env.example y las credenciales reales."

