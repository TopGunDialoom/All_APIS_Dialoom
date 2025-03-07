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
