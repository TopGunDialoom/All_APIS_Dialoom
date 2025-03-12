import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';

/**
 * Ejemplo de guard que detecta si el usuario ha activado modo accesible
 * (podrías leerlo de su perfil, o de un header, etc.).
 * Este snippet es puramente ilustrativo.
 */
@Injectable()
export class AccessibilityGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    // Podrías, por ejemplo, leer un header "x-a11y-mode: true"
    // o un campo en el user (request.user?.preferences?.accessibility)
    const request = context.switchToHttp().getRequest();
    const a11y = request.headers['x-a11y-mode'];
    if (a11y === 'true') {
      // actívate
      return true;
    }
    return true; // no bloqueamos nada, solo logica de ejemplo
  }
}
