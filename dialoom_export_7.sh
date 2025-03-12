#!/usr/bin/env bash
# ==============================================================================
# dialoom_export_7.sh
# Script de exportación para el APARTADO 7: "Gamificación y Engagement"
# ==============================================================================
# Este script genera/actualiza:
#   - src/modules/gamification/ con:
#       * badge.entity.ts
#       * user_badge.entity.ts
#       * gamification.service.ts
#       * gamification.controller.ts
#       * gamification.module.ts
#   - Ajuste en app.module.ts para importar GamificationModule (opcional).
#   - Se asume que la entidad 'User' ya existe. Si no, deberás añadirle 'points' y 'level'.
# ==============================================================================
set -e

BASE_DIR="dialoom-backend"
SRC_DIR="${BASE_DIR}/src"
GAMI_DIR="${SRC_DIR}/modules/gamification"

echo "[INFO] Comenzando script de exportación (apartado 7: Gamificación y Engagement)..."

# Verificar que la carpeta base exista
if [ ! -d "$BASE_DIR" ]; then
  echo "[ERROR] La carpeta '$BASE_DIR' no existe. Asegúrate de haber ejecutado scripts anteriores."
  exit 1
fi

cd "$BASE_DIR"

# Crear el subdirectorio gamification si no existe
echo "[INFO] Creando carpeta '$GAMI_DIR'..."
mkdir -p "$GAMI_DIR"

########################################
# 1. ENTIDAD: badge.entity.ts
########################################
cat <<'EOF' > "$GAMI_DIR/badge.entity.ts"
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

/**
 * Badge: Representa una "insignia" o "logro" que se puede otorgar a usuarios.
 */
@Entity('badges')
export class Badge {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ nullable: true })
  description: string;

  @Column({ nullable: true })
  iconUrl: string;

  // puntos que otorga, si aplica
  @Column({ type: 'int', default: 0 })
  pointsReward: number;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF
echo "[INFO] Creado badge.entity.ts"

########################################
# 2. ENTIDAD: user_badge.entity.ts
########################################
cat <<'EOF' > "$GAMI_DIR/user_badge.entity.ts"
import { Entity, PrimaryGeneratedColumn, ManyToOne, JoinColumn, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Badge } from './badge.entity';

/**
 * Relación pivot User <-> Badge, con la fecha en que se otorgó la insignia.
 */
@Entity('user_badges')
export class UserBadge {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, user => user.id)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Badge)
  @JoinColumn({ name: 'badge_id' })
  badge: Badge;

  @CreateDateColumn()
  awardedAt: Date;
}
EOF
echo "[INFO] Creado user_badge.entity.ts"

########################################
# 3. SERVICE: gamification.service.ts
########################################
cat <<'EOF' > "$GAMI_DIR/gamification.service.ts"
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Badge } from './badge.entity';
import { UserBadge } from './user_badge.entity';
import { User } from '../../users/entities/user.entity';

/**
 * GamificationService:
 * - Cálculo y actualización de puntos / niveles.
 * - Manejo de badges (insignias).
 */
@Injectable()
export class GamificationService {
  constructor(
    @InjectRepository(Badge) private badgeRepo: Repository<Badge>,
    @InjectRepository(UserBadge) private userBadgeRepo: Repository<UserBadge>,
    @InjectRepository(User) private userRepo: Repository<User>,
  ) {}

  // Crear o actualizar una Badge
  async createOrUpdateBadge(id: number, data: Partial<Badge>): Promise<Badge> {
    let badge: Badge;
    if (id) {
      badge = await this.badgeRepo.findOne({ where: { id } });
      if (!badge) throw new NotFoundException('Badge not found');
      Object.assign(badge, data);
    } else {
      badge = this.badgeRepo.create(data);
    }
    return this.badgeRepo.save(badge);
  }

  // Listar badges
  async findAllBadges(): Promise<Badge[]> {
    return this.badgeRepo.find();
  }

  // Otorgar una badge a un user
  async awardBadgeToUser(userId: number, badgeId: number): Promise<UserBadge> {
    const user = await this.userRepo.findOne({ where: { id: userId }});
    if (!user) throw new NotFoundException('User not found');
    const badge = await this.badgeRepo.findOne({ where: { id: badgeId }});
    if (!badge) throw new NotFoundException('Badge not found');

    // Revisar si el user ya la tiene
    const existing = await this.userBadgeRepo.findOne({ where: { user: { id: userId }, badge: { id: badgeId } }});
    if (existing) {
      // ya la tiene
      return existing;
    }
    // Sino, crear
    const ub = this.userBadgeRepo.create({ user, badge });
    // Optionally, sumarle pointsReward
    if (badge.pointsReward && badge.pointsReward > 0) {
      await this.incrementUserPoints(user, badge.pointsReward);
    }
    return this.userBadgeRepo.save(ub);
  }

  // Sumar puntos a un user y check if sube de nivel
  async incrementUserPoints(user: User, additionalPoints: number): Promise<User> {
    user.points = (user.points || 0) + additionalPoints;
    // Lógica de niveles, p.ej. cada 100 pts -> +1 level
    const newLevel = Math.floor((user.points || 0) / 100) + 1; // ejemplo simple
    user.level = newLevel;
    return this.userRepo.save(user);
  }

  // Lógica para awarding badges de forma automatica, p.ej. si user completa X
  // Se puede invocar en hooks de reservaciones, etc.
  async checkAndAwardAchievementBySession(userId: number): Promise<void> {
    // dummy: ej. si user pasa 10 sesiones -> award "Súper Viajero"
    // En la vida real, revisas # de reservas completadas, etc.
  }
}
EOF
echo "[INFO] Creado gamification.service.ts"

########################################
# 4. CONTROLLER: gamification.controller.ts
########################################
cat <<'EOF' > "$GAMI_DIR/gamification.controller.ts"
import { Controller, Get, Post, Body, Param, ParseIntPipe, Patch, UseGuards } from '@nestjs/common';
import { GamificationService } from './gamification.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('gamification')
export class GamificationController {
  constructor(private readonly gamificationService: GamificationService) {}

  // CRUD de badges
  @UseGuards(JwtAuthGuard)
  @Get('badges')
  findAll() {
    return this.gamificationService.findAllBadges();
  }

  // Crear/actualizar badge
  @UseGuards(JwtAuthGuard)
  @Patch('badge/:id')
  updateBadge(@Param('id', ParseIntPipe) id: number, @Body() dto: any) {
    return this.gamificationService.createOrUpdateBadge(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Post('badge/create')
  createBadge(@Body() dto: any) {
    return this.gamificationService.createOrUpdateBadge(null, dto);
  }

  // Award badge
  @UseGuards(JwtAuthGuard)
  @Post('award')
  async awardBadge(
    @Body() body: { userId: number; badgeId: number },
  ) {
    return this.gamificationService.awardBadgeToUser(body.userId, body.badgeId);
  }
}
EOF
echo "[INFO] Creado gamification.controller.ts"

########################################
# 5. MODULE: gamification.module.ts
########################################
cat <<'EOF' > "$GAMI_DIR/gamification.module.ts"
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { GamificationService } from './gamification.service';
import { GamificationController } from './gamification.controller';
import { Badge } from './badge.entity';
import { UserBadge } from './user_badge.entity';
import { User } from '../users/entities/user.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([Badge, UserBadge, User]),
  ],
  controllers: [GamificationController],
  providers: [GamificationService],
  exports: [GamificationService],
})
export class GamificationModule {}
EOF
echo "[INFO] Creado gamification.module.ts"

########################################
# 6. Insertar en app.module.ts
########################################
APP_MODULE_PATH="${SRC_DIR}/app.module.ts"
if [ -f "$APP_MODULE_PATH" ]; then
  if grep -q "GamificationModule" "$APP_MODULE_PATH"; then
    echo "[INFO] app.module.ts ya contiene 'GamificationModule'. No se modifica."
  else
    echo "[INFO] Insertando GamificationModule en app.module.ts..."
    sed -i.bak "s%@Module({%@Module({\
  imports: [ GamificationModule ],%g" "$APP_MODULE_PATH"
    # También insert import { GamificationModule }
    if ! grep -q "import { GamificationModule" "$APP_MODULE_PATH"; then
      sed -i.bak "1i import { GamificationModule } from './modules/gamification/gamification.module';" "$APP_MODULE_PATH"
    fi
  fi
else
  echo "[WARN] No se encontró app.module.ts. Agrega manualmente: 'GamificationModule' en imports."
fi

########################################
# 7. Mensaje final
########################################
echo "[DONE] Script completado para APARTADO 7 (Gamificación y Engagement)."
echo "Revisa '${GAMI_DIR}' para ver badge.entity.ts, user_badge.entity.ts, gamification.service.ts, etc."
echo "Asegúrate de que la entidad 'User' tenga campos 'points: number' y 'level: number'."
echo "Si sed no funcionó como esperas en app.module.ts, edita manualmente."
