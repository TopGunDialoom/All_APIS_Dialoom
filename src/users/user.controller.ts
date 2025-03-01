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
