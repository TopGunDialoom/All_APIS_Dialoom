#!/usr/bin/env bash
# ==========================================================================
# export_apartado4.sh
# Script para generar/actualizar archivos correspondientes al
# "Apartado 4: Roles de Usuario y Funcionalidades" en Dialoom.
# ==========================================================================
# 1) Se asume que YA tienes la estructura previa (app.module.ts, main.ts, etc.)
# 2) Este script añade/ajusta los archivos de roles y lógicas de funcionalidades
#    para usuarios, hosts, admins, etc.
# 3) Ajusta a tus rutas según convenga, aquí seguimos la convención src/modules/...
# ==========================================================================

echo "Creando/actualizando directorios específicos para 'Roles de Usuario y Funcionalidades'..."

mkdir -p src/common/decorators
mkdir -p src/common/guards
mkdir -p src/modules/users
mkdir -p src/modules/users/dto
mkdir -p src/modules/users/entities
mkdir -p src/modules/users/controllers
mkdir -p src/modules/users/services
mkdir -p src/modules/admin
mkdir -p src/modules/admin/controllers
mkdir -p src/modules/admin/services
mkdir -p src/modules/admin/entities

echo "================================================================"
echo " Generando archivo src/common/decorators/roles.decorator.ts ..."
echo "================================================================"

cat << '__EOC__' > src/common/decorators/roles.decorator.ts
import { SetMetadata } from '@nestjs/common';

/**
 * Ejemplo de roles en la plataforma Dialoom:
 * - 'user': rol de cliente normal
 * - 'host': mentor que ofrece sesiones
 * - 'admin': superadministrador
 */
export const ROLES_KEY = 'roles';

/**
 * Decorador para especificar los roles permitidos en un endpoint:
 * @example
 *  @Roles('admin', 'host')
 *  findAllHosts() { ... }
 */
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);
__EOC__


echo "================================================================"
echo " Generando archivo src/common/guards/roles.guard.ts ..."
echo "================================================================"

cat << '__EOC__' > src/common/guards/roles.guard.ts
import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../decorators/roles.decorator';

/**
 * RolesGuard se basa en un decorador @Roles(...) para permitir
 * o denegar el acceso al endpoint.
 * Asume que en el request.user existe user.role (string).
 */
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(
      ROLES_KEY,
      [context.getHandler(), context.getClass()],
    );
    if (!requiredRoles || requiredRoles.length === 0) {
      // No se especificaron roles => acceso libre
      return true;
    }
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    if (!user) {
      throw new ForbiddenException('No user found in request');
    }
    const hasRole = requiredRoles.includes(user.role);
    if (!hasRole) {
      throw new ForbiddenException(
        \`No tienes acceso. Se requiere uno de estos roles: \${requiredRoles.join(', ')}\`,
      );
    }
    return true;
  }
}
__EOC__


echo "================================================================"
echo " Generando archivo src/modules/users/entities/user.entity.ts ..."
echo "================================================================"

cat << '__EOC__' > src/modules/users/entities/user.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Exclude } from 'class-transformer';

/**
 * Roles posibles dentro de Dialoom para un usuario en general:
 * - user (cliente)
 * - host (mentor)
 * - admin (superadministrador)
 */
export enum UserRole {
  USER = 'user',
  HOST = 'host',
  ADMIN = 'admin',
}

@Entity('users')
export class User {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ length: 100 })
  name!: string;

  @Column({ unique: true })
  email!: string;

  /**
   * Contraseña con hash bcrypt
   * Excluimos de la serialización con class-transformer
   */
  @Exclude()
  @Column()
  password!: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.USER,
  })
  role!: UserRole;

  // Podríamos poner isVerified, twoFactorEnabled, etc. si hicimos 2FA
  // @Column({ default: false })
  // isVerified!: boolean;

  @CreateDateColumn()
  createdAt!: Date;

  @UpdateDateColumn()
  updatedAt!: Date;
}
__EOC__


echo "================================================================"
echo " Generando dto: src/modules/users/dto/create-user.dto.ts ..."
echo "================================================================"

cat << '__EOC__' > src/modules/users/dto/create-user.dto.ts
import { IsEmail, IsString, MinLength, MaxLength, IsOptional } from 'class-validator';
import { UserRole } from '../entities/user.entity';

export class CreateUserDto {
  @IsString()
  @MaxLength(100)
  name: string;

  @IsEmail()
  email: string;

  @IsString()
  @MinLength(6)
  password: string;

  @IsOptional()
  role?: UserRole; // Por defecto user si no se proporciona
}
__EOC__


echo "================================================================"
echo " Generando dto: src/modules/users/dto/update-user.dto.ts ..."
echo "================================================================"

cat << '__EOC__' > src/modules/users/dto/update-user.dto.ts
import { IsString, IsOptional, MaxLength } from 'class-validator';
import { UserRole } from '../entities/user.entity';

export class UpdateUserDto {
  @IsOptional()
  @IsString()
  @MaxLength(100)
  name?: string;

  @IsOptional()
  role?: UserRole;  // cambiar el rol si es admin
}
__EOC__


echo "================================================================"
echo " Generando archivo src/modules/users/services/users.service.ts ..."
echo "================================================================"

cat << '__EOC__' > src/modules/users/services/users.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from '../entities/user.entity';
import { CreateUserDto } from '../dto/create-user.dto';
import { UpdateUserDto } from '../dto/update-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly usersRepo: Repository<User>,
  ) {}

  async findAll(): Promise<User[]> {
    return this.usersRepo.find();
  }

  async findById(id: number): Promise<User> {
    const user = await this.usersRepo.findOne({ where: { id } });
    if (!user) {
      throw new NotFoundException(\`User with id=\${id} not found\`);
    }
    return user;
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepo.findOne({ where: { email } });
  }

  async createUser(dto: CreateUserDto): Promise<User> {
    const { name, email, password, role } = dto;
    // Verificar si ya existe
    const existing = await this.findByEmail(email);
    if (existing) {
      throw new Error('Email already in use');
    }
    const hashed = await bcrypt.hash(password, 10);
    const user = this.usersRepo.create({
      name,
      email,
      password: hashed,
      role: role || UserRole.USER,
    });
    return this.usersRepo.save(user);
  }

  async updateUser(id: number, dto: UpdateUserDto): Promise<User> {
    const user = await this.findById(id);
    if (dto.name !== undefined) {
      user.name = dto.name;
    }
    if (dto.role !== undefined) {
      user.role = dto.role;
    }
    return this.usersRepo.save(user);
  }

  async removeUser(id: number): Promise<void> {
    const user = await this.findById(id);
    await this.usersRepo.remove(user);
  }
}
__EOC__


echo "================================================================"
echo " Generando archivo src/modules/users/controllers/users.controller.ts ..."
echo "================================================================"

cat << '__EOC__' > src/modules/users/controllers/users.controller.ts
import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  ParseIntPipe,
  UseGuards,
  Req,
  ForbiddenException,
} from '@nestjs/common';
import { UsersService } from '../services/users.service';
import { CreateUserDto } from '../dto/create-user.dto';
import { UpdateUserDto } from '../dto/update-user.dto';
import { JwtAuthGuard } from '../../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../../common/guards/roles.guard';
import { Roles } from '../../../common/decorators/roles.decorator';
import { UserRole } from '../entities/user.entity';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  /**
   * Endpoints para admins (o hosts) que quieran listar usuarios
   * Este es un ejemplo: /users con rol admin
   */
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @Get()
  findAll() {
    return this.usersService.findAll();
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @Get(':id')
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.usersService.findById(id);
  }

  /**
   * Crea un usuario (p.e. un admin crea a un host, etc.)
   * Podría también ser un endpoint público, pero en muchos casos
   * lo manejamos en auth.controller con register
   */
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @Post()
  create(@Body() dto: CreateUserDto) {
    return this.usersService.createUser(dto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @Patch(':id')
  update(
    @Param('id', ParseIntPipe) id: number,
    @Body() dto: UpdateUserDto,
  ) {
    return this.usersService.updateUser(id, dto);
  }

  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @Delete(':id')
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.usersService.removeUser(id);
  }

  /**
   * Ejemplo: Endpoint para que un user u host consulte su propio perfil.
   * Se valida que id == req.user.id, o rol=admin
   */
  @UseGuards(JwtAuthGuard)
  @Get('profile/:id')
  async getOwnProfile(
    @Param('id', ParseIntPipe) userId: number,
    @Req() req: any,
  ) {
    const requestUser = req.user;
    if (requestUser.role !== UserRole.ADMIN && requestUser.id !== userId) {
      throw new ForbiddenException('No puedes ver el perfil de otro usuario');
    }
    return this.usersService.findById(userId);
  }
}
__EOC__


echo "================================================================"
echo " Ajustes en src/modules/users/users.module.ts ..."
echo "================================================================"

cat << '__EOC__' > src/modules/users/users.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { UsersService } from './services/users.service';
import { UsersController } from './controllers/users.controller';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService], // para que AuthService use UsersService
})
export class UsersModule {}
__EOC__


echo "================================================================"
echo " Generando parte de Admin (ejemplo de Rol superadmin) ..."
echo "================================================================"

cat << '__EOC__' > src/modules/admin/entities/admin-log.entity.ts
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

/**
 * Ejemplo de log de acciones admin: 'DELETE_USER', 'UPDATE_HOST', etc.
 * Solo demostración de "funcionalidades" de rol admin.
 */
@Entity('admin_logs')
export class AdminLog {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  action!: string;

  @Column({ nullable: true })
  details?: string;

  @CreateDateColumn()
  createdAt!: Date;
}
__EOC__


cat << '__EOC__' > src/modules/admin/services/admin.service.ts
import { Injectable, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AdminLog } from '../entities/admin-log.entity';
import { UsersService } from '../../users/services/users.service';
import { User, UserRole } from '../../users/entities/user.entity';

/**
 * Ejemplo de service que hace acciones 'privadas' de admin:
 * - upgrade user -> host
 * - ban user
 * - etc.
 */
@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(AdminLog)
    private readonly logsRepo: Repository<AdminLog>,
    private readonly usersService: UsersService,
  ) {}

  async banUser(userId: number, reason: string) {
    // BAN => Cambiamos rol a 'user' con algo, o bloqueado
    const user = await this.usersService.findById(userId);
    if (user.role === UserRole.ADMIN) {
      throw new ForbiddenException('No puedes banear a un admin');
    }
    // Podríamos hacer "eliminar" o setear "role=host_banned", etc.
    // Por simplicidad, removeUser
    await this.usersService.removeUser(userId);

    const log = this.logsRepo.create({
      action: 'BAN_USER',
      details: \`banned user \${userId}, reason: \${reason}\`,
    });
    await this.logsRepo.save(log);
    return { message: \`User \${userId} was banned.\` };
  }

  async promoteToHost(userId: number) {
    const user = await this.usersService.findById(userId);
    if (user.role === UserRole.HOST) {
      throw new Error('User is already a host');
    }
    user.role = UserRole.HOST;
    await this.usersService.updateUser(userId, { role: UserRole.HOST });
    const log = this.logsRepo.create({
      action: 'PROMOTE_TO_HOST',
      details: \`user \${userId} => host\`,
    });
    await this.logsRepo.save(log);
    return { message: \`User \${userId} is now a host.\` };
  }

  async promoteToAdmin(userId: number) {
    // Quiza solo un superadmin puede hacer esto, verifica en admin.controller con RolesGuard
    await this.usersService.updateUser(userId, { role: UserRole.ADMIN });
    const log = this.logsRepo.create({
      action: 'PROMOTE_TO_ADMIN',
      details: \`user \${userId} => admin\`,
    });
    await this.logsRepo.save(log);
    return { message: \`User \${userId} is now admin.\` };
  }

  async getLogs() {
    return this.logsRepo.find({
      order: { createdAt: 'DESC' },
      take: 50,
    });
  }
}
__EOC__


cat << '__EOC__' > src/modules/admin/controllers/admin.controller.ts
import { Controller, Post, Body, Param, ParseIntPipe, Get, UseGuards } from '@nestjs/common';
import { AdminService } from '../services/admin.service';
import { JwtAuthGuard } from '../../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../../common/guards/roles.guard';
import { Roles } from '../../../common/decorators/roles.decorator';

@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin') // Cualquier endpoint en este controller => rol admin
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Post('ban-user/:id')
  banUser(@Param('id', ParseIntPipe) userId: number, @Body('reason') reason: string) {
    return this.adminService.banUser(userId, reason);
  }

  @Post('promote-host/:id')
  promoteToHost(@Param('id', ParseIntPipe) userId: number) {
    return this.adminService.promoteToHost(userId);
  }

  @Post('promote-admin/:id')
  promoteToAdmin(@Param('id', ParseIntPipe) userId: number) {
    return this.adminService.promoteToAdmin(userId);
  }

  @Get('logs')
  getLogs() {
    return this.adminService.getLogs();
  }
}
__EOC__


cat << '__EOC__' > src/modules/admin/admin.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminLog } from './entities/admin-log.entity';
import { AdminService } from './services/admin.service';
import { AdminController } from './controllers/admin.controller';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([AdminLog]), UsersModule],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
__EOC__


echo "================================================================"
echo "Recordatorio: En tu app.module.ts ya deberías tener importado:"
echo "  AdminModule, UsersModule, etc. para rolear la logica"
echo "================================================================"

echo "Hecho. Se han creado/actualizado archivos relativos al 'Apartado 4:"
echo "Roles de Usuario y Funcionalidades' con un ejemplo de Admin, Host y User."
echo "==========================================================================="
echo "FIN del script."
