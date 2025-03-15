import { Controller, Get, Res, Req } from '@nestjs/common';
import { Response, Request } from 'express';

@Controller('auth')
export class AuthController {
  @Get('test')
  test(@Req() req: Request, @Res() res: Response) {
    const jwt = '123abc';
    // Cerrar backtick y remover caracteres extra
    return res.redirect(`dialoom://auth?token=${jwt}`);
  }
}
