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
