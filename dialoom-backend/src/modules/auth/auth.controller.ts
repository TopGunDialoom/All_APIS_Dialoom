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
