import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    private jwtService: JwtService
  ) {}

  /**
   * validateUser:
   * - Compara la password con el hash.
   * - Retorna true o false (o un user object) según convenga.
   */
  async validateUser(passwordPlain: string, passwordHash: string): Promise<boolean> {
    const match = await bcrypt.compare(passwordPlain, passwordHash);
    if (!match) {
      throw new UnauthorizedException('Invalid password');
    }
    return true;
  }

  /**
   * Genera token JWT
   */
  generateToken(payload: { userId: number; role: string }) {
    return this.jwtService.sign(payload);
  }
}
