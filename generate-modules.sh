#!/bin/bash

#######################################################
# Script para generar todos los módulos de Dialoom
#######################################################

# 1. Módulo de Usuarios
echo "Generando módulo de Usuarios..."
mkdir -p src/modules/users/dto
mkdir -p src/modules/users/entities

# Entidad User
cat > src/modules/users/entities/user.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany, ManyToOne, ManyToMany, JoinTable } from 'typeorm';
import { Exclude } from 'class-transformer';
import { Role } from '../../roles/entities/role.entity';
import { Booking } from '../../bookings/entities/booking.entity';
import { Review } from '../../reviews/entities/review.entity';
import { Provider } from '../../providers/entities/provider.entity';
import { Favorite } from '../../favorites/entities/favorite.entity';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 100 })
  fullName: string;

  @Column({ unique: true })
  email: string;

  @Column()
  @Exclude()
  password: string;

  @Column({ nullable: true })
  phoneNumber: string;

  @Column({ nullable: true })
  profilePicture: string;

  @Column({ default: true })
  isActive: boolean;

  @ManyToOne(() => Role, role => role.users)
  role: Role;

  @OneToMany(() => Booking, booking => booking.user)
  bookings: Booking[];

  @OneToMany(() => Review, review => review.user)
  reviews: Review[];

  @OneToMany(() => Provider, provider => provider.user, { nullable: true })
  providerProfile: Provider[];

  @OneToMany(() => Favorite, favorite => favorite.user)
  favorites: Favorite[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

# DTOs para User
cat > src/modules/users/dto/create-user.dto.ts << 'EOF'
import { IsEmail, IsNotEmpty, IsString, MinLength, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ description: 'Nombre completo del usuario' })
  @IsNotEmpty()
  @IsString()
  fullName: string;

  @ApiProperty({ description: 'Correo electrónico único del usuario' })
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @ApiProperty({ description: 'Contraseña del usuario (mínimo 6 caracteres)' })
  @IsNotEmpty()
  @IsString()
  @MinLength(6)
  password: string;

  @ApiPropertyOptional({ description: 'Número de teléfono del usuario' })
  @IsOptional()
  @IsString()
  phoneNumber?: string;

  @ApiPropertyOptional({ description: 'ID del rol asignado' })
  @IsOptional()
  @IsString()
  roleId?: string;
}
EOF

cat > src/modules/users/dto/update-user.dto.ts << 'EOF'
import { PartialType } from '@nestjs/swagger';
import { CreateUserDto } from './create-user.dto';
import { IsOptional, IsBoolean } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateUserDto extends PartialType(CreateUserDto) {
  @ApiPropertyOptional({ description: 'Estado de activación del usuario' })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  // Se heredan los campos opcionales de CreateUserDto
}
EOF

# Servicio de usuarios
cat > src/modules/users/users.service.ts << 'EOF'
import { Injectable, NotFoundException, ConflictException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private usersRepository: Repository<User>,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    // Verificar si el email ya existe
    const existingUser = await this.usersRepository.findOne({
      where: { email: createUserDto.email }
    });
    
    if (existingUser) {
      throw new ConflictException('El correo electrónico ya está registrado');
    }

    // Encriptar contraseña
    const hashedPassword = await bcrypt.hash(createUserDto.password, 10);
    
    // Crear nuevo usuario
    const newUser = this.usersRepository.create({
      ...createUserDto,
      password: hashedPassword,
    });

    return this.usersRepository.save(newUser);
  }

  async findAll(): Promise<User[]> {
    return this.usersRepository.find({
      relations: ['role'],
    });
  }

  async findOne(id: string): Promise<User> {
    const user = await this.usersRepository.findOne({
      where: { id },
      relations: ['role', 'bookings', 'reviews', 'providerProfile', 'favorites'],
    });
    
    if (!user) {
      throw new NotFoundException('Usuario no encontrado');
    }
    
    return user;
  }

  async findByEmail(email: string): Promise<User> {
    const user = await this.usersRepository.findOne({
      where: { email },
      relations: ['role'],
    });
    
    if (!user) {
      throw new NotFoundException('Usuario no encontrado');
    }
    
    return user;
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    const user = await this.findOne(id);
    
    // Si se incluye una nueva contraseña, encriptarla
    if (updateUserDto.password) {
      updateUserDto.password = await bcrypt.hash(updateUserDto.password, 10);
    }
    
    // Actualizar usuario
    const updatedUser = this.usersRepository.merge(user, updateUserDto);
    return this.usersRepository.save(updatedUser);
  }

  async remove(id: string): Promise<void> {
    const user = await this.findOne(id);
    await this.usersRepository.remove(user);
  }
}
EOF

# Controlador de usuarios
cat > src/modules/users/users.controller.ts << 'EOF'
import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards } from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiResponse } from '@nestjs/swagger';

@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @ApiOperation({ summary: 'Crear un nuevo usuario' })
  @ApiResponse({ status: 201, description: 'Usuario creado exitosamente' })
  @ApiResponse({ status: 400, description: 'Datos de entrada inválidos' })
  @ApiResponse({ status: 409, description: 'El correo ya está registrado' })
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto);
  }

  @Get()
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener todos los usuarios' })
  @ApiResponse({ status: 200, description: 'Lista de usuarios recuperada' })
  @ApiResponse({ status: 403, description: 'Acceso denegado' })
  findAll() {
    return this.usersService.findAll();
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener un usuario por ID' })
  @ApiResponse({ status: 200, description: 'Usuario encontrado' })
  @ApiResponse({ status: 404, description: 'Usuario no encontrado' })
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Actualizar un usuario' })
  @ApiResponse({ status: 200, description: 'Usuario actualizado exitosamente' })
  @ApiResponse({ status: 404, description: 'Usuario no encontrado' })
  update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.usersService.update(id, updateUserDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard, RolesGuard)
  @Roles('admin')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Eliminar un usuario' })
  @ApiResponse({ status: 200, description: 'Usuario eliminado exitosamente' })
  @ApiResponse({ status: 404, description: 'Usuario no encontrado' })
  remove(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
EOF

# Módulo de usuarios
cat > src/modules/users/users.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { User } from './entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  controllers: [UsersController],
  providers: [UsersService],
  exports: [UsersService],
})
export class UsersModule {}
EOF

# 2. Módulo de Roles
echo "Generando módulo de Roles..."
mkdir -p src/modules/roles/dto
mkdir -p src/modules/roles/entities

# Entidad Role
cat > src/modules/roles/entities/role.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToMany } from 'typeorm';
import { User } from '../../users/entities/user.entity';

@Entity('roles')
export class Role {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  name: string;

  @Column({ nullable: true })
  description: string;

  @OneToMany(() => User, user => user.role)
  users: User[];

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

# DTOs para Role
cat > src/modules/roles/dto/create-role.dto.ts << 'EOF'
import { IsNotEmpty, IsString, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateRoleDto {
  @ApiProperty({ description: 'Nombre del rol' })
  @IsNotEmpty()
  @IsString()
  name: string;

  @ApiPropertyOptional({ description: 'Descripción del rol' })
  @IsOptional()
  @IsString()
  description?: string;
}
EOF

cat > src/modules/roles/dto/update-role.dto.ts << 'EOF'
import { PartialType } from '@nestjs/swagger';
import { CreateRoleDto } from './create-role.dto';

export class UpdateRoleDto extends PartialType(CreateRoleDto) {}
EOF

# Servicio de roles
cat > src/modules/roles/roles.service.ts << 'EOF'
import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Role } from './entities/role.entity';
import { CreateRoleDto } from './dto/create-role.dto';
import { UpdateRoleDto } from './dto/update-role.dto';

@Injectable()
export class RolesService {
  constructor(
    @InjectRepository(Role)
    private rolesRepository: Repository<Role>,
  ) {}

  async create(createRoleDto: CreateRoleDto): Promise<Role> {
    // Verificar si el rol ya existe
    const existingRole = await this.rolesRepository.findOne({
      where: { name: createRoleDto.name }
    });
    
    if (existingRole) {
      throw new ConflictException('Ya existe un rol con este nombre');
    }

    const newRole = this.rolesRepository.create(createRoleDto);
    return this.rolesRepository.save(newRole);
  }

  async findAll(): Promise<Role[]> {
    return this.rolesRepository.find();
  }

  async findOne(id: string): Promise<Role> {
    const role = await this.rolesRepository.findOne({
      where: { id },
      relations: ['users'],
    });
    
    if (!role) {
      throw new NotFoundException('Rol no encontrado');
    }
    
    return role;
  }

  async findByName(name: string): Promise<Role> {
    const role = await this.rolesRepository.findOne({
      where: { name },
    });
    
    if (!role) {
      throw new NotFoundException('Rol no encontrado');
    }
    
    return role;
  }

  async update(id: string, updateRoleDto: UpdateRoleDto): Promise<Role> {
    const role = await this.findOne(id);
    
    // Si se está actualizando el nombre, verificar que no exista otro rol con ese nombre
    if (updateRoleDto.name && updateRoleDto.name !== role.name) {
      const existingRole = await this.rolesRepository.findOne({
        where: { name: updateRoleDto.name }
      });
      
      if (existingRole) {
        throw new ConflictException('Ya existe un rol con este nombre');
      }
    }
    
    const updatedRole = this.rolesRepository.merge(role, updateRoleDto);
    return this.rolesRepository.save(updatedRole);
  }

  async remove(id: string): Promise<void> {
    const role = await this.findOne(id);
    await this.rolesRepository.remove(role);
  }

  // Método para inicializar roles predeterminados
  async initializeDefaultRoles(): Promise<void> {
    const defaultRoles = [
      { name: 'admin', description: 'Administrador del sistema' },
      { name: 'user', description: 'Usuario regular' },
      { name: 'provider', description: 'Proveedor de servicios' },
    ];

    for (const roleData of defaultRoles) {
      const existingRole = await this.rolesRepository.findOne({
        where: { name: roleData.name }
      });
      
      if (!existingRole) {
        const newRole = this.rolesRepository.create(roleData);
        await this.rolesRepository.save(newRole);
      }
    }
  }
}
EOF

# Controlador de roles
cat > src/modules/roles/roles.controller.ts << 'EOF'
import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards } from '@nestjs/common';
import { RolesService } from './roles.service';
import { CreateRoleDto } from './dto/create-role.dto';
import { UpdateRoleDto } from './dto/update-role.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiResponse } from '@nestjs/swagger';

@ApiTags('roles')
@Controller('roles')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('admin')
@ApiBearerAuth()
export class RolesController {
  constructor(private readonly rolesService: RolesService) {}

  @Post()
  @ApiOperation({ summary: 'Crear un nuevo rol' })
  @ApiResponse({ status: 201, description: 'Rol creado exitosamente' })
  @ApiResponse({ status: 400, description: 'Datos de entrada inválidos' })
  @ApiResponse({ status: 409, description: 'El nombre del rol ya existe' })
  create(@Body() createRoleDto: CreateRoleDto) {
    return this.rolesService.create(createRoleDto);
  }

  @Get()
  @ApiOperation({ summary: 'Obtener todos los roles' })
  @ApiResponse({ status: 200, description: 'Lista de roles recuperada' })
  findAll() {
    return this.rolesService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener un rol por ID' })
  @ApiResponse({ status: 200, description: 'Rol encontrado' })
  @ApiResponse({ status: 404, description: 'Rol no encontrado' })
  findOne(@Param('id') id: string) {
    return this.rolesService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Actualizar un rol' })
  @ApiResponse({ status: 200, description: 'Rol actualizado exitosamente' })
  @ApiResponse({ status: 400, description: 'Datos de entrada inválidos' })
  @ApiResponse({ status: 404, description: 'Rol no encontrado' })
  @ApiResponse({ status: 409, description: 'El nombre del rol ya existe' })
  update(@Param('id') id: string, @Body() updateRoleDto: UpdateRoleDto) {
    return this.rolesService.update(id, updateRoleDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Eliminar un rol' })
  @ApiResponse({ status: 200, description: 'Rol eliminado exitosamente' })
  @ApiResponse({ status: 404, description: 'Rol no encontrado' })
  remove(@Param('id') id: string) {
    return this.rolesService.remove(id);
  }
}
EOF

# Módulo de roles
cat > src/modules/roles/roles.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { RolesService } from './roles.service';
import { RolesController } from './roles.controller';
import { Role } from './entities/role.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Role])],
  controllers: [RolesController],
  providers: [RolesService],
  exports: [RolesService],
})
export class RolesModule {}
EOF

# 3. Módulo de Autenticación
echo "Generando módulo de Autenticación..."
mkdir -p src/modules/auth/dto
mkdir -p src/modules/auth/guards
mkdir -p src/modules/auth/strategies

# DTOs para Auth
cat > src/modules/auth/dto/login.dto.ts << 'EOF'
import { IsEmail, IsNotEmpty, IsString, MinLength } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class LoginDto {
  @ApiProperty({ description: 'Correo electrónico del usuario' })
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @ApiProperty({ description: 'Contraseña del usuario' })
  @IsNotEmpty()
  @IsString()
  password: string;
}
EOF

cat > src/modules/auth/dto/register.dto.ts << 'EOF'
import { IsEmail, IsNotEmpty, IsString, MinLength, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class RegisterDto {
  @ApiProperty({ description: 'Nombre completo del usuario' })
  @IsNotEmpty()
  @IsString()
  fullName: string;

  @ApiProperty({ description: 'Correo electrónico único del usuario' })
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @ApiProperty({ description: 'Contraseña del usuario (mínimo 6 caracteres)' })
  @IsNotEmpty()
  @IsString()
  @MinLength(6)
  password: string;

  @ApiPropertyOptional({ description: 'Número de teléfono del usuario' })
  @IsOptional()
  @IsString()
  phoneNumber?: string;
}
EOF

# Estrategias de autenticación
cat > src/modules/auth/strategies/jwt.strategy.ts << 'EOF'
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { UsersService } from '../../users/users.service';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    private usersService: UsersService,
    private configService: ConfigService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET'),
    });
  }

  async validate(payload: any) {
    const user = await this.usersService.findOne(payload.sub);
    
    if (!user || !user.isActive) {
      throw new UnauthorizedException('Usuario no válido o inactivo');
    }
    
    return {
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      role: user.role?.name || 'user',
    };
  }
}
EOF

cat > src/modules/auth/strategies/local.strategy.ts << 'EOF'
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-local';
import { AuthService } from '../auth.service';

@Injectable()
export class LocalStrategy extends PassportStrategy(Strategy) {
  constructor(private authService: AuthService) {
    super({
      usernameField: 'email',
    });
  }

  async validate(email: string, password: string) {
    const user = await this.authService.validateUser(email, password);
    
    if (!user) {
      throw new UnauthorizedException('Credenciales inválidas');
    }
    
    return user;
  }
}
EOF

# Guards de autenticación
cat > src/modules/auth/guards/jwt-auth.guard.ts << 'EOF'
import { Injectable, ExecutionContext } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  canActivate(context: ExecutionContext) {
    return super.canActivate(context);
  }
}
EOF

cat > src/modules/auth/guards/local-auth.guard.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class LocalAuthGuard extends AuthGuard('local') {}
EOF

# Servicio de autenticación
cat > src/modules/auth/auth.service.ts << 'EOF'
import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { RolesService } from '../roles/roles.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private rolesService: RolesService,
    private jwtService: JwtService,
  ) {}

  async validateUser(email: string, password: string): Promise<any> {
    try {
      const user = await this.usersService.findByEmail(email);
      
      // Verificar si la contraseña coincide
      const isPasswordValid = await bcrypt.compare(password, user.password);
      
      if (isPasswordValid) {
        const { password, ...result } = user;
        return result;
      }
      
      return null;
    } catch (error) {
      return null;
    }
  }

  async login(loginDto: LoginDto) {
    const user = await this.validateUser(loginDto.email, loginDto.password);
    
    if (!user) {
      throw new UnauthorizedException('Credenciales inválidas');
    }

    // Verificar si el usuario está activo
    if (!user.isActive) {
      throw new UnauthorizedException('Cuenta inactiva. Contacte al administrador.');
    }
    
    const payload = {
      email: user.email,
      sub: user.id,
      role: user.role?.name || 'user',
    };
    
    return {
      user: {
        id: user.id,
        email: user.email,
        fullName: user.fullName,
        role: user.role?.name || 'user',
      },
      accessToken: this.jwtService.sign(payload),
    };
  }

  async register(registerDto: RegisterDto) {
    // Buscar rol de usuario regular
    let userRole;
    try {
      userRole = await this.rolesService.findByName('user');
    } catch (error) {
      // Si no existe, crear el rol de usuario
      userRole = await this.rolesService.create({
        name: 'user',
        description: 'Usuario regular',
      });
    }

    // Crear el usuario con el rol asignado
    const newUser = await this.usersService.create({
      ...registerDto,
      roleId: userRole.id,
    });

    // Retornar usuario sin la contraseña
    const { password, ...result } = newUser;
    
    // Generar token
    const payload = {
      email: newUser.email,
      sub: newUser.id,
      role: 'user',
    };
    
    return {
      user: {
        id: newUser.id,
        email: newUser.email,
        fullName: newUser.fullName,
        role: 'user',
      },
      accessToken: this.jwtService.sign(payload),
    };
  }

  async getProfile(userId: string) {
    return this.usersService.findOne(userId);
  }
}
EOF

# Controlador de autenticación
cat > src/modules/auth/auth.controller.ts << 'EOF'
import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { LocalAuthGuard } from './guards/local-auth.guard';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiResponse } from '@nestjs/swagger';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('login')
  @ApiOperation({ summary: 'Iniciar sesión' })
  @ApiResponse({ status: 200, description: 'Inicio de sesión exitoso' })
  @ApiResponse({ status: 401, description: 'Credenciales inválidas' })
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Post('register')
  @ApiOperation({ summary: 'Registrar un nuevo usuario' })
  @ApiResponse({ status: 201, description: 'Usuario registrado exitosamente' })
  @ApiResponse({ status: 400, description: 'Datos de entrada inválidos' })
  @ApiResponse({ status: 409, description: 'El correo ya está registrado' })
  async register(@Body() registerDto: RegisterDto) {
    return this.authService.register(registerDto);
  }

  @Get('profile')
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener el perfil del usuario autenticado' })
  @ApiResponse({ status: 200, description: 'Perfil recuperado exitosamente' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async getProfile(@Request() req) {
    return this.authService.getProfile(req.user.id);
  }
}
EOF

# Módulo de autenticación
cat > src/modules/auth/auth.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from '../users/users.module';
import { RolesModule } from '../roles/roles.module';
import { LocalStrategy } from './strategies/local.strategy';
import { JwtStrategy } from './strategies/jwt.strategy';

@Module({
  imports: [
    UsersModule,
    RolesModule,
    PassportModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        secret: configService.get<string>('JWT_SECRET'),
        signOptions: { expiresIn: configService.get<string>('JWT_EXPIRATION', '1d') },
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [AuthController],
  providers: [AuthService, LocalStrategy, JwtStrategy],
  exports: [AuthService],
})
export class AuthModule {}
EOF

# 4. Decoradores y Guards comunes
echo "Generando utilidades comunes..."

# Decorador de roles
cat > src/common/decorators/roles.decorator.ts << 'EOF'
import { SetMetadata } from '@nestjs/common';

export const ROLES_KEY = 'roles';
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);
EOF

# Guard de roles
cat > src/common/guards/roles.guard.ts << 'EOF'
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../decorators/roles.decorator';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredRoles) {
      return true;
    }

    const { user } = context.switchToHttp().getRequest();
    return requiredRoles.some((role) => user.role === role);
  }
}
EOF

# 5. Generación de más módulos
echo "Generando otros módulos..."

# Módulo de servicios (services)
mkdir -p src/modules/services/dto
mkdir -p src/modules/services/entities

cat > src/modules/services/entities/service.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, OneToMany } from 'typeorm';
import { Provider } from '../../providers/entities/provider.entity';
import { Booking } from '../../bookings/entities/booking.entity';
import { Review } from '../../reviews/entities/review.entity';
import { Favorite } from '../../favorites/entities/favorite.entity';

@Entity('services')
export class Service {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column('text')
  description: string;

  @Column('decimal', { precision: 10, scale: 2 })
  price: number;

  @Column()
  duration: number; // Duración en minutos

  @Column({ default: true })
  isActive: boolean;

  @Column({ nullable: true })
  image: string;

  @Column({ nullable: true })
  category: string;

  @ManyToOne(() => Provider, provider => provider.services)
  provider: Provider;

  @OneToMany(() => Booking, booking => booking.service)
  bookings: Booking[];

  @OneToMany(() => Review, review => review.service)
  reviews: Review[];

  @OneToMany(() => Favorite, favorite => favorite.service)
  favorites: Favorite[];

  @Column({ default: 0 })
  averageRating: number;

  @Column({ default: 0 })
  reviewCount: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

# Otros módulos (esqueletos básicos)

mkdir -p src/modules/bookings/dto
mkdir -p src/modules/bookings/entities

cat > src/modules/bookings/entities/booking.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Service } from '../../services/entities/service.entity';
import { Provider } from '../../providers/entities/provider.entity';

@Entity('bookings')
export class Booking {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, user => user.bookings)
  user: User;

  @ManyToOne(() => Service, service => service.bookings)
  service: Service;

  @ManyToOne(() => Provider, provider => provider.bookings)
  provider: Provider;

  @Column()
  date: Date;

  @Column()
  startTime: Date;

  @Column()
  endTime: Date;

  @Column({
    type: 'enum',
    enum: ['pending', 'confirmed', 'cancelled', 'completed'],
    default: 'pending'
  })
  status: string;

  @Column({ nullable: true })
  notes: string;

  @Column({ nullable: true })
  paymentId: string;

  @Column({ default: false })
  isPaid: boolean;

  @Column('decimal', { precision: 10, scale: 2 })
  amount: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

mkdir -p src/modules/payments/dto
mkdir -p src/modules/payments/entities

cat > src/modules/payments/entities/payment.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, OneToOne, JoinColumn } from 'typeorm';
import { Booking } from '../../bookings/entities/booking.entity';

@Entity('payments')
export class Payment {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  bookingId: string;

  @OneToOne(() => Booking)
  @JoinColumn({ name: 'bookingId' })
  booking: Booking;

  @Column()
  transactionId: string;

  @Column('decimal', { precision: 10, scale: 2 })
  amount: number;

  @Column({
    type: 'enum',
    enum: ['pending', 'completed', 'failed', 'refunded'],
    default: 'pending'
  })
  status: string;

  @Column({ nullable: true })
  paymentMethod: string;

  @Column({ nullable: true })
  paymentProvider: string;

  @Column({ nullable: true, type: 'json' })
  paymentDetails: any;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

mkdir -p src/modules/reviews/dto
mkdir -p src/modules/reviews/entities

cat > src/modules/reviews/entities/review.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Service } from '../../services/entities/service.entity';
import { Provider } from '../../providers/entities/provider.entity';

@Entity('reviews')
export class Review {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, user => user.reviews)
  user: User;

  @ManyToOne(() => Service, service => service.reviews, { nullable: true })
  service: Service;

  @ManyToOne(() => Provider, provider => provider.reviews, { nullable: true })
  provider: Provider;

  @Column()
  rating: number;

  @Column({ nullable: true })
  comment: string;

  @Column({ default: true })
  isVisible: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

mkdir -p src/modules/providers/dto
mkdir -p src/modules/providers/entities

cat > src/modules/providers/entities/provider.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, OneToMany } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Service } from '../../services/entities/service.entity';
import { Booking } from '../../bookings/entities/booking.entity';
import { Review } from '../../reviews/entities/review.entity';
import { Favorite } from '../../favorites/entities/favorite.entity';

@Entity('providers')
export class Provider {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, user => user.providerProfile)
  user: User;

  @Column()
  businessName: string;

  @Column({ nullable: true })
  description: string;

  @Column({ nullable: true })
  address: string;

  @Column({ nullable: true })
  website: string;

  @Column({ nullable: true })
  phoneNumber: string;

  @Column({ nullable: true })
  profilePicture: string;

  @Column({ nullable: true, type: 'json' })
  businessHours: any;

  @Column({ default: true })
  isActive: boolean;

  @Column({ default: false })
  isVerified: boolean;

  @Column({ nullable: true })
  category: string;

  @OneToMany(() => Service, service => service.provider)
  services: Service[];

  @OneToMany(() => Booking, booking => booking.provider)
  bookings: Booking[];

  @OneToMany(() => Review, review => review.provider)
  reviews: Review[];

  @OneToMany(() => Favorite, favorite => favorite.provider)
  favorites: Favorite[];

  @Column({ default: 0 })
  averageRating: number;

  @Column({ default: 0 })
  reviewCount: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

mkdir -p src/modules/favorites/dto
mkdir -p src/modules/favorites/entities

cat > src/modules/favorites/entities/favorite.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, CreateDateColumn, ManyToOne, Unique } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Service } from '../../services/entities/service.entity';
import { Provider } from '../../providers/entities/provider.entity';

@Entity('favorites')
@Unique(['user', 'service', 'provider'])
export class Favorite {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => User, user => user.favorites)
  user: User;

  @ManyToOne(() => Service, service => service.favorites, { nullable: true })
  service: Service;

  @ManyToOne(() => Provider, provider => provider.favorites, { nullable: true })
  provider: Provider;

  @CreateDateColumn()
  createdAt: Date;
}
EOF

mkdir -p src/modules/locations/dto
mkdir -p src/modules/locations/entities

cat > src/modules/locations/entities/location.entity.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne } from 'typeorm';
import { Provider } from '../../providers/entities/provider.entity';

@Entity('locations')
export class Location {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ManyToOne(() => Provider)
  provider: Provider;

  @Column()
  name: string;

  @Column()
  address: string;

  @Column({ nullable: true })
  city: string;

  @Column({ nullable: true })
  state: string;

  @Column({ nullable: true })
  country: string;

  @Column({ nullable: true })
  postalCode: string;

  @Column({ type: 'decimal', precision: 10, scale: 7, nullable: true })
  latitude: number;

  @Column({ type: 'decimal', precision: 10, scale: 7, nullable: true })
  longitude: number;

  @Column({ nullable: true })
  phoneNumber: string;

  @Column({ default: true })
  isActive: boolean;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

# Script para inicializar la base de datos
cat > src/config/seed.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { AppModule } from '../app.module';
import { RolesService } from '../modules/roles/roles.service';
import { UsersService } from '../modules/users/users.service';
import * as bcrypt from 'bcrypt';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const rolesService = app.get(RolesService);
  const usersService = app.get(UsersService);

  // Inicializar roles
  await rolesService.initializeDefaultRoles();

  // Buscar rol de administrador
  const adminRole = await rolesService.findByName('admin');

  // Verificar si ya existe un usuario administrador
  try {
    await usersService.findByEmail('admin@dialoom.com');
    console.log('El usuario administrador ya existe');
  } catch (error) {
    // Crear usuario administrador
    const adminUser = await usersService.create({
      fullName: 'Admin User',
      email: 'admin@dialoom.com',
      password: 'admin123',
      roleId: adminRole.id,
    });
    console.log('Usuario administrador creado:', adminUser.email);
  }

  console.log('Base de datos inicializada correctamente');
  await app.close();
}

bootstrap();
EOF

echo "Generación de módulos completada."
