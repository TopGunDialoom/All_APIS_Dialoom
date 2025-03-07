import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { UserRole } from '../../modules/users/entities/user.entity';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.get<UserRole[]>('roles', context.getHandler());
    if (!requiredRoles || requiredRoles.length === 0) {
      return true; // no se requiere rol específico
    }
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    if (!user) {
      return false;
    }
    const hasRole = requiredRoles.includes(user.role);
    if (!hasRole) {
      throw new ForbiddenException('No tienes permiso para acceder a este recurso');
    }
    return true;
  }
}
