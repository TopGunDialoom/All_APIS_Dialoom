import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import AppleStrategyPassport from 'passport-apple';

@Injectable()
export class AppleStrategy extends PassportStrategy(
  AppleStrategyPassport.Strategy,
  'apple',
) {
  constructor() {
    super({
      clientID: process.env.APPLE_CLIENT_ID || '',
      teamID: process.env.APPLE_TEAM_ID || '',
      callbackURL: process.env.APPLE_CALLBACK_URL || 'http://localhost:3000/auth/apple/callback',
      keyID: process.env.APPLE_KEY_ID || '',
      privateKeyString: process.env.APPLE_PRIVATE_KEY || '',
      scope: ['name', 'email'],
    });
  }

  async validate(
    accessToken: string,
    refreshToken: string,
    profile: any,
  ): Promise<any> {
    // Devuelve el usuario
    return { ...profile };
  }
}
