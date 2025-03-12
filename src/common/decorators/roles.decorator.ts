import { SetMetadata } from '@nestjs/common';

/**
 * Ejemplo de roles en la plataforma Dialoom:
 * - 'user': rol de cliente normal
 * - 'host': mentor que ofrece sesiones
 * - 'admin': superadministrador
 */
export const ROLES_KEY = 'roles';

/**
 * Decorador para especificar los roles permitidos en un endpoint:
 * @example
 *  @Roles('admin', 'host')
 *  findAllHosts() { ... }
 */
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);
