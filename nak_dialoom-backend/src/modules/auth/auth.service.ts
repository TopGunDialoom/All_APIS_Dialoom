import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { User, UserRole } from '../users/entities/user.entity';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async validateOAuthLogin(provider: string, oauthProfile: any): Promise<User> {
    // Se espera que oauthProfile contenga email y un id unico
    const email = oauthProfile.email;
    const name = oauthProfile.name || oauthProfile.displayName;
    if (!email) {
      throw new UnauthorizedException('No email provided by OAuth profile');
    }
    // Buscar usuario
    let user = await this.usersService.findByEmail(email);
    if (!user) {
      // Crear usuario
      user = await this.usersService.createOAuthUser(name, email, UserRole.USER);
    }
    return user;
  }

  generateJwt(user: User): string {
    const payload = { sub: user.id, role: user.role, email: user.email };
    return this.jwtService.sign(payload);
  }

  // Verificar 2FA (ejemplo, supón que tenemos guardado secret TOTP en user.twoFactorSecret)
  verify2FA(user: User, code: string): boolean {
    // Implementar la verificación real (ej: speakeasy.totp.verify...)
    if (!user.twoFactorEnabled) return true; // no requiere 2FA
    // TODO: Lógica real
    return true;
  }
}
