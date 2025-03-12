#!/usr/bin/env bash
# ==========================================================================
# dialoom_backend_auth.sh
# Script de exportación para el apartado 3 (Autenticación y Seguridad)
# Esto añade/ajusta los archivos de AuthModule y UsersModule necesarios
# ==========================================================================

echo "Creando carpetas para Auth y Users..."
mkdir -p src/auth/strategies
mkdir -p src/auth/guards
mkdir -p src/auth/dto
mkdir -p src/users
mkdir -p src/users/entities

echo "Creando archivo src/auth/auth.module.ts..."
cat << '__EOC__' > src/auth/auth.module.ts
import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from 'src/users/users.module';
import { LocalStrategy } from './strategies/local.strategy';
import { JwtStrategy } from './strategies/jwt.strategy';

// Para login social (futuro):
// import { GoogleStrategy } from './strategies/google.strategy';
// import { AppleStrategy } from './strategies/apple.strategy';
// import { FacebookStrategy } from './strategies/facebook.strategy';
// etc.

@Module({
  imports: [
    UsersModule,
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('JWT_SECRET') || 'JWT_DEFAULT_SECRET',
        signOptions: {
          expiresIn: '7d', // Ajusta el tiempo de expiración según requieras
        },
      }),
      inject: [ConfigService],
    }),
  ],
  providers: [
    AuthService,
    LocalStrategy,
    JwtStrategy,
    // GoogleStrategy, AppleStrategy, etc. (cuando se activen)
  ],
  controllers: [AuthController],
  exports: [AuthService],
})
export class AuthModule {}
EOC__

echo "Creando archivo src/auth/auth.controller.ts..."
cat << '__EOC__' > src/auth/auth.controller.ts
import { Controller, Post, Body, UseGuards, Request } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LocalAuthGuard } from './guards/local-auth.guard';
import { LoginDto } from './dto/login.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @UseGuards(LocalAuthGuard)
  @Post('login')
  async login(@Body() loginDto: LoginDto, @Request() req: any) {
    // req.user viene del LocalStrategy (si validó OK)
    return this.authService.login(req.user);
  }

  @Post('register')
  async register(@Body() body: any) {
    // Podrías usar un dto RegisterDto
    // en este ejemplo, asumo body = { email, password, name, ... }
    return this.authService.register(body);
  }
}
EOC__

echo "Creando archivo src/auth/auth.service.ts..."
cat << '__EOC__' > src/auth/auth.service.ts
import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from 'src/users/users.service';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    private readonly usersService: UsersService,
    private readonly jwtService: JwtService
  ) {}

  // validateUser -> usado por local.strategy
  async validateUser(email: string, pass: string) {
    const user = await this.usersService.findByEmail(email);
    if (!user) {
      throw new UnauthorizedException('User not found');
    }
    const isMatch = await bcrypt.compare(pass, user.password);
    if (!isMatch) {
      throw new UnauthorizedException('Invalid credentials');
    }
    return user;
  }

  // login -> genera el JWT
  async login(user: any) {
    // El objeto user que devuelves podría tener id, email, role, etc.
    const payload = { sub: user.id, email: user.email, role: user.role || 'user' };
    return {
      access_token: this.jwtService.sign(payload),
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
        // ... lo que quieras exponer
      },
    };
  }

  // register -> crea un usuario nuevo
  async register(dto: any) {
    // Ver si email ya existe
    const existing = await this.usersService.findByEmail(dto.email);
    if (existing) {
      throw new ConflictException('Email is already in use');
    }
    // Podrías validad, hashear pass, etc.
    const hashedPass = await bcrypt.hash(dto.password, 10);
    const newUser = await this.usersService.createUser({
      ...dto,
      password: hashedPass,
    });
    return { message: 'User registered', userId: newUser.id };
  }
}
EOC__

echo "Creando archivo src/auth/dto/login.dto.ts..."
cat << '__EOC__' > src/auth/dto/login.dto.ts
import { IsEmail, IsString, MinLength } from 'class-validator';

export class LoginDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(4)
  password: string;
}
EOC__

echo "Creando archivo src/auth/dto/register.dto.ts (ejemplo sin usarlo mucho)..."
cat << '__EOC__' > src/auth/dto/register.dto.ts
import { IsEmail, IsString, MinLength, IsOptional } from 'class-validator';

export class RegisterDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(4)
  password: string;

  @IsString()
  @IsOptional()
  name?: string;
}
EOC__

echo "Creando archivo src/auth/strategies/local.strategy.ts..."
cat << '__EOC__' > src/auth/strategies/local.strategy.ts
import { Strategy } from 'passport-local';
import { PassportStrategy } from '@nestjs/passport';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { AuthService } from '../auth.service';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly authService: AuthService) {
    // Por defecto, passport-local usa campos username, password
    // Sobrescribimos para usar email en vez de username
    super({ usernameField: 'email' });
  }

  async validate(email: string, password: string): Promise<any> {
    const user = await this.authService.validateUser(email, password);
    if (!user) {
      throw new UnauthorizedException();
    }
    return user;
  }
}
EOC__

echo "Creando archivo src/auth/strategies/jwt.strategy.ts..."
cat << '__EOC__' > src/auth/strategies/jwt.strategy.ts
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET') || 'JWT_DEFAULT_SECRET',
    });
  }

  // payload = { sub: user.id, email: user.email, role, iat, exp, ... }
  async validate(payload: any) {
    // Podrías inyectar UserService para refinar
    return { userId: payload.sub, email: payload.email, role: payload.role || 'user' };
  }
}
EOC__

echo "Creando archivo src/auth/guards/local-auth.guard.ts..."
cat << '__EOC__' > src/auth/guards/local-auth.guard.ts
import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class LocalAuthGuard extends AuthGuard('local') {}
EOC__

echo "Creando archivo src/auth/guards/jwt-auth.guard.ts..."
cat << '__EOC__' > src/auth/guards/jwt-auth.guard.ts
import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
EOC__

echo "Creando archivo src/users/users.module.ts..."
cat << '__EOC__' > src/users/users.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersService } from './users.service';
import { User } from './entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
EOC__

echo "Creando archivo src/users/users.service.ts..."
cat << '__EOC__' > src/users/users.service.ts
import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from './entities/user.entity';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepo: Repository<User>
  ) {}

  async findByEmail(email: string): Promise<User | null> {
    return this.userRepo.findOne({ where: { email } });
  }

  async createUser(dto: any): Promise<User> {
    // dto = { email, password, name, ... }
    const user = this.userRepo.create(dto);
    return this.userRepo.save(user);
  }

  // Extra methods: findById, updateUser, etc.
}
EOC__

echo "Creando archivo src/users/entities/user.entity.ts..."
cat << '__EOC__' > src/users/entities/user.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

export enum UserRole {
  USER = 'user',
  HOST = 'host',
  ADMIN = 'admin',
  SUPERADMIN = 'superadmin',
}

@Entity({ name: 'users' })
export class User {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ unique: true })
  email!: string;

  @Column()
  password!: string;

  @Column({ type: 'enum', enum: UserRole, default: UserRole.USER })
  role!: UserRole;

  @Column({ nullable: true })
  name?: string;

  @CreateDateColumn()
  createdAt!: Date;
}
EOC__

echo "Listo. Se han creado/actualizado los archivos para AUTH y USERS."
echo "============================================"
echo "RECUERDA:"
echo "1) Revisar tu archivo src/app.module.ts o principal para importar AuthModule."
echo "2) Asegurar que TypeOrm está configurado para MySQL en config (en tu 'app.module.ts')."
echo "3) Editar .env con JWT_SECRET y ajusta si quieres."
echo "4) Podrías habilitar 2FA o login social en el futuro."
echo "============================================"
exit 0
