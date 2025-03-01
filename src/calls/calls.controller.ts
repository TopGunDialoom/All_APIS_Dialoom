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
