#!/usr/bin/env bash
# =============================================================================
# dialoom_export_admin10.sh
# Script para exportar el apartado 10: "Panel de Administración" - Dialoom
# =============================================================================
set -e

echo "[INFO] Iniciando script de exportación (Apartado 10: Panel de Administración)..."

# 1) Verificar carpeta dialoom-backend
if [ -d "dialoom-backend" ]; then
  echo "[INFO] Directorio 'dialoom-backend' detectado."
else
  echo "[INFO] Creando 'dialoom-backend' pues no existe..."
  mkdir dialoom-backend
fi

cd dialoom-backend

# 2) Crear subcarpeta para admin module si no existe
echo "[INFO] Creando src/modules/admin..."
mkdir -p src/modules/admin
mkdir -p src/modules/admin/dto
mkdir -p src/modules/admin/entities

# ----------------------------------------------------------------------------
# 3) admin.module.ts
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/admin/admin.module.ts
import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
// Suponiendo que tu "UsersModule", "PaymentsModule", etc. ya existen
import { UsersModule } from '../users/users.module';
import { PaymentsModule } from '../payments/payments.module';
import { ReservationsModule } from '../reservations/reservations.module'; // si existe
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
// import { ReservationEntity } from '../reservations/entities/reservation.entity'; // si lo deseas
// import { SomeAdminEntity } from './entities/some-admin.entity';

@Module({
  imports: [
    forwardRef(() => UsersModule),
    forwardRef(() => PaymentsModule),
    // forwardRef(() => ReservationsModule), // si lo tienes creado
    // TypeOrmModule.forFeature([SomeAdminEntity]),
  ],
  controllers: [AdminController],
  providers: [AdminService],
  exports: [AdminService],
})
export class AdminModule {}
EOF

# ----------------------------------------------------------------------------
# 4) admin.service.ts
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/admin/admin.service.ts
import { Injectable, Logger, BadRequestException } from '@nestjs/common';
import { UsersService } from '../users/users.service'; // asumiendo que existe
import { PaymentsService } from '../payments/payments.service'; // asumiendo
// import { ReservationsService } from '../reservations/reservations.service'; // si existe

@Injectable()
export class AdminService {
  private readonly logger = new Logger(AdminService.name);

  constructor(
    private readonly usersService: UsersService,
    private readonly paymentsService: PaymentsService,
    // private readonly reservationsService: ReservationsService,
  ) {}

  /**
   * Ejemplo: Obtener info de un user, forzando su ban, etc.
   */
  async banUser(userId: number): Promise<void> {
    this.logger.warn(`Baneando user con ID=${userId} (ejemplo)`);
    const user = await this.usersService.findById(userId);
    if (!user) {
      throw new BadRequestException('Usuario no encontrado');
    }
    // user.isBanned = true; // si tu entity user tiene esa prop
    await this.usersService.saveUser(user);
    // la acción de ban se registra en logs o en una entidad de logs
  }

  /**
   * Ejemplo de ver transacciones globales.
   */
  async getAllTransactions() {
    return this.paymentsService.findAllTransactions(); // asumiendo tengas un findAll
  }

  /**
   * Ej: Ajustar la comisión global en stripe, etc.
   */
  async setCommissionRate(newRate: number) {
    // tu logic
    this.logger.log(`Set commissionRate = ${newRate} (placeholder).`);
    // Podrías usar un SettingService, o config global
  }

  // ... añade aquí la lógica de admin que requieras
}
EOF

# ----------------------------------------------------------------------------
# 5) admin.controller.ts
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/admin/admin.controller.ts
import { Controller, Get, Post, Param, Body, UseGuards } from '@nestjs/common';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard'; // asumiendo lo tienes
import { RolesGuard } from '../../common/guards/roles.guard'; // si usas roles
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from '../../modules/users/entities/user.entity'; // si tienes un enum

@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.ADMIN) // asumiendo tienes un rol admin
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Post('ban-user/:id')
  async banUser(@Param('id') userId: string): Promise<void> {
    return this.adminService.banUser(Number(userId));
  }

  @Get('transactions')
  async getAllTransactions() {
    return this.adminService.getAllTransactions();
  }

  @Post('commission')
  async setCommissionRate(@Body() data: { newRate: number }) {
    return this.adminService.setCommissionRate(data.newRate);
  }

  // ... etc. Otros endpoints administrativos
}
EOF

# ----------------------------------------------------------------------------
# 6) Insertar import { AdminModule } en app.module.ts y en su imports
# ----------------------------------------------------------------------------
if [ -f "src/app.module.ts" ]; then
  if grep -q "AdminModule" src/app.module.ts; then
    echo "[INFO] AdminModule ya existe en app.module.ts, no se modifica."
  else
    echo "[INFO] Insertando AdminModule en app.module.ts"
    sed -i.bak "/^import.*AuthModule.*/a import { AdminModule } from './modules/admin/admin.module';" src/app.module.ts || true
    sed -i.bak "s/\(imports: *\[[^]]*\)/\1,\n    AdminModule/" src/app.module.ts || true
  fi
else
  echo "[WARN] app.module.ts no encontrado; no insertamos AdminModule automáticamente."
fi

# ----------------------------------------------------------------------------
# 7) Extra: Ajustes a .env si quieres algo como ADMIN_EMAIL, etc.
# ----------------------------------------------------------------------------
if [ -f ".env" ]; then
  echo "[INFO] Actualizando .env con una variable de ejemplo ADMIN_EMAIL (si no existe)."
  if ! grep -q "ADMIN_EMAIL=" .env; then
    echo "ADMIN_EMAIL=admin@dialoom.com" >> .env
  fi
else
  echo "[INFO] Creando .env con una variable ADMIN_EMAIL"
  cat <<EOT > .env
ADMIN_EMAIL=admin@dialoom.com
EOT
fi

echo "[DONE] Script finalizado para el apartado 10 (Panel de Administración)."
echo "Revisa src/modules/admin/* para ver los archivos generados."
