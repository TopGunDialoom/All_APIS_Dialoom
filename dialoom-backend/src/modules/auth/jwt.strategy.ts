import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy, ExtractJwt } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_SECRET || 'DialoomJWTSecret',
    });
  }

  async validate(payload: any) {
    // Podrías buscar el usuario en DB, etc.
    if (!payload.userId) {
      throw new UnauthorizedException('Token inválido');
    }
    return payload; // user object in request
  }
}
