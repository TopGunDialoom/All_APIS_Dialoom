#!/usr/bin/env bash
# ==============================================================================
# dialoom_export_8.sh
# Script de exportación para el APARTADO 8: "Moderación y Reportes"
# ==============================================================================
# Este script genera/actualiza:
#   - src/modules/moderation/ con:
#       * report.entity.ts
#       * moderation.service.ts
#       * moderation.controller.ts
#       * moderation.module.ts
#   - Ajuste en admin.controller.ts (si existe) o crea uno básico
#   - Ajuste en app.module.ts para importar ModerationModule (opcional).
# ==============================================================================
set -e

BASE_DIR="dialoom-backend"
SRC_DIR="${BASE_DIR}/src"
MODERATION_DIR="${SRC_DIR}/modules/moderation"

echo "[INFO] Comenzando script de exportación (apartado 8: Moderación y Reportes)..."

# Verificar que la carpeta base exista
if [ ! -d "$BASE_DIR" ]; then
  echo "[ERROR] La carpeta '$BASE_DIR' no existe. Asegúrate de haber ejecutado scripts anteriores."
  exit 1
fi

cd "$BASE_DIR"

# Crear el subdirectorio moderation si no existe
echo "[INFO] Creando carpeta '$MODERATION_DIR'..."
mkdir -p "$MODERATION_DIR"

########################################
# 1. ENTIDAD: report.entity.ts
########################################
cat <<'EOF' > "$MODERATION_DIR/report.entity.ts"
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  JoinColumn,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';

/**
 * Representa un reporte de conducta o incidencia
 * Hecho por un usuario "reporter" contra "accused" (otro user),
 * con un status e información adicional.
 */
@Entity('reports')
export class Report {
  @PrimaryGeneratedColumn()
  id: number;

  // quién crea el reporte
  @ManyToOne(() => User)
  @JoinColumn({ name: 'reporter_id' })
  reporter: User;

  // a quién se reporta (accusado), puede ser null si se reporta algo general
  @ManyToOne(() => User, { nullable: true })
  @JoinColumn({ name: 'accused_id' })
  accused: User;

  // razón/categoría (ej. "conducta inapropiada", "no se presentó", etc.)
  @Column({ length: 200, nullable: true })
  reason: string;

  // descripción libre
  @Column({ type: 'text', nullable: true })
  details: string;

  // estado del reporte: pending, in_progress, resolved, dismissed
  @Column({ length: 50, default: 'pending' })
  status: string;

  // posible acción tomada: warning, ban, etc.
  @Column({ length: 100, nullable: true })
  actionTaken: string;

  // comentarios del admin/moderador
  @Column({ type: 'text', nullable: true })
  moderatorNotes: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF
echo "[INFO] Creado report.entity.ts"

########################################
# 2. SERVICE: moderation.service.ts
########################################
cat <<'EOF' > "$MODERATION_DIR/moderation.service.ts"
import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Report } from './report.entity';
import { User } from '../../users/entities/user.entity';

@Injectable()
export class ModerationService {
  constructor(
    @InjectRepository(Report) private readonly reportRepo: Repository<Report>,
    @InjectRepository(User) private readonly userRepo: Repository<User>,
  ) {}

  // Crear un reporte
  async createReport(
    reporterId: number,
    accusedId: number,
    reason: string,
    details?: string,
  ): Promise<Report> {
    if (!reason) {
      throw new BadRequestException('Reason is required');
    }
    const reporter = await this.userRepo.findOne({ where: { id: reporterId } });
    if (!reporter) {
      throw new NotFoundException('Reporter user not found');
    }
    let accused: User = null;
    if (accusedId) {
      accused = await this.userRepo.findOne({ where: { id: accusedId } });
      if (!accused) {
        throw new NotFoundException('Accused user not found');
      }
    }
    const report = this.reportRepo.create({
      reporter,
      accused,
      reason,
      details,
      status: 'pending',
    });
    return this.reportRepo.save(report);
  }

  // Listar reportes (para admin)
  async findAllReports(): Promise<Report[]> {
    return this.reportRepo.find({
      relations: ['reporter', 'accused'],
      order: { createdAt: 'DESC' },
    });
  }

  // Ver un reporte puntual
  async findOneReport(id: number): Promise<Report> {
    const rpt = await this.reportRepo.findOne({
      where: { id },
      relations: ['reporter', 'accused'],
    });
    if (!rpt) throw new NotFoundException('Report not found');
    return rpt;
  }

  // Actualizar el estado o la acción
  async updateReport(id: number, updates: Partial<Report>): Promise<Report> {
    const rpt = await this.findOneReport(id);
    Object.assign(rpt, updates);
    return this.reportRepo.save(rpt);
  }

  // Posible método para banear
  async banUser(userId: number, reason: string) {
    // Lógica de baneo: user.isBanned = true, etc.
    // O user.status = 'banned'.
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new NotFoundException('User to ban not found');
    // supondremos que la entidad user tiene un campo isBanned: boolean
    user['isBanned'] = true;
    await this.userRepo.save(user);
    // Podríamos crear un "report" interno con action=ban
    return user;
  }
}
EOF
echo "[INFO] Creado moderation.service.ts"

########################################
# 3. CONTROLLER: moderation.controller.ts
########################################
cat <<'EOF' > "$MODERATION_DIR/moderation.controller.ts"
import { Controller, Post, Get, Patch, Param, Body, UseGuards, ParseIntPipe } from '@nestjs/common';
import { ModerationService } from './moderation.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
// se asume que tienes un RolesGuard o algo similar
// import { RolesGuard } from '../../common/guards/roles.guard';
// import { Roles } from '../../common/decorators/roles.decorator';
// import { UserRole } from '../users/entities/user.entity';

@Controller('moderation')
export class ModerationController {
  constructor(private readonly moderationService: ModerationService) {}

  /**
   * Crear un reporte. Cualquier usuario logueado podría reportar.
   */
  @UseGuards(JwtAuthGuard)
  @Post('report')
  async createReport(@Body() body: { reporterId: number; accusedId?: number; reason: string; details?: string; }) {
    const { reporterId, accusedId, reason, details } = body;
    return this.moderationService.createReport(reporterId, accusedId, reason, details);
  }

  /**
   * Listar reportes (solo admin)
   */
  @UseGuards(JwtAuthGuard)
  // @UseGuards(RolesGuard)
  // @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  @Get('reports')
  async findAllReports() {
    return this.moderationService.findAllReports();
  }

  /**
   * Ver un reporte puntual (solo admin)
   */
  @UseGuards(JwtAuthGuard)
  // @UseGuards(RolesGuard)
  // @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  @Get('report/:id')
  async getOne(@Param('id', ParseIntPipe) id: number) {
    return this.moderationService.findOneReport(id);
  }

  /**
   * Actualizar un reporte, ej. status o acción. (solo admin)
   */
  @UseGuards(JwtAuthGuard)
  // @UseGuards(RolesGuard)
  // @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  @Patch('report/:id')
  async updateReport(@Param('id', ParseIntPipe) id: number, @Body() updates: any) {
    return this.moderationService.updateReport(id, updates);
  }

  /**
   * Banear a un usuario (solo admin). Ejemplo.
   */
  @UseGuards(JwtAuthGuard)
  // @UseGuards(RolesGuard)
  // @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  @Post('ban-user')
  async banUser(@Body() body: { userId: number; reason?: string }) {
    return this.moderationService.banUser(body.userId, body.reason || 'No reason');
  }
}
EOF
echo "[INFO] Creado moderation.controller.ts"

########################################
# 4. MODULE: moderation.module.ts
########################################
cat <<'EOF' > "$MODERATION_DIR/moderation.module.ts"
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ModerationService } from './moderation.service';
import { ModerationController } from './moderation.controller';
import { Report } from './report.entity';
import { User } from '../users/entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Report, User])],
  controllers: [ModerationController],
  providers: [ModerationService],
  exports: [ModerationService],
})
export class ModerationModule {}
EOF
echo "[INFO] Creado moderation.module.ts"

########################################
# 5. Insertar en app.module.ts si se desea
########################################
APP_MODULE_PATH="${SRC_DIR}/app.module.ts"
if [ -f "$APP_MODULE_PATH" ]; then
  if grep -q "ModerationModule" "$APP_MODULE_PATH"; then
    echo "[INFO] app.module.ts ya contiene 'ModerationModule'. No se modifica."
  else
    echo "[INFO] Insertando ModerationModule en app.module.ts..."
    sed -i.bak "s%@Module({%@Module({\
  imports: [ ModerationModule ],%g" "$APP_MODULE_PATH"
    # También insert import { ModerationModule }
    if ! grep -q "import { ModerationModule" "$APP_MODULE_PATH"; then
      sed -i.bak "1i import { ModerationModule } from './modules/moderation/moderation.module';" "$APP_MODULE_PATH"
    fi
  fi
else
  echo "[WARN] No se encontró app.module.ts. Agrega manualmente: 'ModerationModule' en imports."
fi

########################################
# 6. Mensaje final
########################################
echo "[DONE] Script completado para APARTADO 8 (Moderación y Reportes)."
echo "Revisa '${MODERATION_DIR}' para ver report.entity.ts, moderation.service.ts, etc."
echo "Asegúrate de tener un guard/admin roles si deseas restringir endpoints."
echo "Si sed no funcionó como esperas en app.module.ts, edita manualmente."
