import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-facebook';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

@Injectable()
export class FacebookStrategy extends PassportStrategy(Strategy, 'facebook') {
  constructor(private configService: ConfigService, private authService: AuthService) {
    super({
      clientID: configService.get<string>('FACEBOOK_APP_ID'),
      clientSecret: configService.get<string>('FACEBOOK_APP_SECRET'),
      callbackURL: 'http://localhost:3000/auth/facebook/redirect',
      profileFields: ['id', 'emails', 'name']
    });
  }

  async validate(accessToken: string, refreshToken: string, profile: any) {
    const { name, emails } = profile;
    const email = emails && emails[0]?.value;
    const fullName = name?.givenName + ' ' + name?.familyName;
    const oauthProfile = { name: fullName, email };
    const user = await this.authService.validateOAuthLogin('facebook', oauthProfile);
    return user;
  }
}
