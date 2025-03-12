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
