#!/usr/bin/env bash
# ==============================================================================
# dialoom_export_5.sh
# Script de exportación para el APARTADO 5: "Gestión de Reservas y Videollamadas"
# ==============================================================================
# Este script asume que ya hay un proyecto NestJS configurado
# con la estructura base (scripts anteriores).
# Agregará:
#   - src/modules/reservations/
#   - Lógica de BookingService para CRUD, integración con Agora
#   - Entidades Reservation, etc.
#   - Controlador ReservationsController
#   - Ajustes en app.module.ts (si no existen, se añadirán)
# ==============================================================================

set -e

# Ruta base (puedes ajustarla o dejarla en ".")
BASE_DIR="dialoom-backend"
SRC_DIR="${BASE_DIR}/src"
RESERVATIONS_DIR="${SRC_DIR}/modules/reservations"

echo "[INFO] Comenzando script de exportación (apartado 5: reservas y videollamadas)..."

# Verificar que la carpeta base exista
if [ ! -d "$BASE_DIR" ]; then
  echo "[ERROR] La carpeta '$BASE_DIR' no existe. Asegúrate de haber ejecutado scripts anteriores."
  exit 1
fi

echo "[INFO] Entrando en carpeta '$BASE_DIR'..."
cd "$BASE_DIR"

# Crear el subdirectorio de módulos "reservations" si no existe
echo "[INFO] Creando carpeta para ReservationsModule en '$RESERVATIONS_DIR'..."
mkdir -p "$RESERVATIONS_DIR"

########################################
# 1. ENTIDAD: reservation.entity.ts
########################################
cat <<'EOF' > "$RESERVATIONS_DIR/reservation.entity.ts"
import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from '../users/entities/user.entity';
// Si tienes un "Host" distinto a "User", import that entity.
// O si host es un user con role=host, ajusta la relación a "mentor: User" con role=host

@Entity('reservations')
export class Reservation {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'user_id' })
  user: User; // cliente

  @ManyToOne(() => User)
  @JoinColumn({ name: 'mentor_id' })
  mentor: User; // si lo manejas con user role=host

  @Column({ type: 'datetime' })
  startTime: Date;

  @Column({ type: 'int', default: 60 })
  durationMinutes: number;

  @Column({ default: '' })
  agoraChannel: string; // Nombre/canal de Agora

  @Column({ default: '' })
  status: string; // p.ej. 'PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED'

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF
echo "[INFO] Creado reservation.entity.ts"

########################################
# 2. SERVICE: reservations.service.ts
########################################
cat <<'EOF' > "$RESERVATIONS_DIR/reservations.service.ts"
import { Injectable, NotFoundException, BadRequestException, Inject, forwardRef } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Reservation } from './reservation.entity';
import { ConfigService } from '@nestjs/config';
import { User } from '../users/entities/user.entity';

// Agora token generation
import { RtcRole, RtcTokenBuilder } from 'agora-access-token';
// "agora-access-token" ^2.0.0 (ya está en package.json)

@Injectable()
export class ReservationsService {
  constructor(
    @InjectRepository(Reservation)
    private reservationRepo: Repository<Reservation>,
    private configService: ConfigService,
  ) {}

  async createReservation(userId: number, mentorId: number, startTime: Date, duration: number = 60): Promise<Reservation> {
    // Podrías verificar disponibilidad de mentor, etc.
    // Lógica simplificada:
    const newRes = this.reservationRepo.create({
      user: { id: userId } as User,
      mentor: { id: mentorId } as User,
      startTime,
      durationMinutes: duration,
      status: 'PENDING'
    });
    return await this.reservationRepo.save(newRes);
  }

  async confirmReservation(resId: number): Promise<Reservation> {
    const res = await this.reservationRepo.findOne({ where: { id: resId }, relations: ['user', 'mentor'] });
    if (!res) {
      throw new NotFoundException('Reservation not found');
    }
    // Cambiar estado a CONFIRMED, generar agoraChannel
    res.status = 'CONFIRMED';
    res.agoraChannel = `dialoom_res_${res.id}`; // canal para la llamada
    return await this.reservationRepo.save(res);
  }

  async cancelReservation(resId: number): Promise<Reservation> {
    const res = await this.reservationRepo.findOne({ where: { id: resId } });
    if (!res) {
      throw new NotFoundException('Reservation not found');
    }
    res.status = 'CANCELLED';
    return await this.reservationRepo.save(res);
  }

  async getReservation(id: number): Promise<Reservation> {
    const r = await this.reservationRepo.findOne({
      where: { id },
      relations: ['user', 'mentor']
    });
    if (!r) {
      throw new NotFoundException('Reservation not found');
    }
    return r;
  }

  async getAllReservations(): Promise<Reservation[]> {
    return this.reservationRepo.find({
      relations: ['user', 'mentor']
    });
  }

  // Generar token de Agora con el appID, appCert de config
  generateAgoraToken(channelName: string, userId: string | number, role: RtcRole = RtcRole.PUBLISHER): string {
    const agoraAppId = this.configService.get<string>('AGORA_APP_ID');
    const agoraCert = this.configService.get<string>('AGORA_APP_CERT');
    if (!agoraAppId || !agoraCert) {
      throw new BadRequestException('Agora credentials not configured');
    }
    const expireTimeSeconds = 2 * 60 * 60; // 2 horas
    const currentTimestamp = Math.floor(Date.now() / 1000);
    const privilegeExpiredTs = currentTimestamp + expireTimeSeconds;

    const token = RtcTokenBuilder.buildTokenWithUid(
      agoraAppId,
      agoraCert,
      channelName,
      String(userId),
      role,
      privilegeExpiredTs
    );
    return token;
  }

  // Generar tokens para user y mentor
  async getCallTokens(resId: number, requestingUserId: number) {
    const res = await this.reservationRepo.findOne({
      where: { id: resId },
      relations: ['user', 'mentor']
    });
    if (!res) throw new NotFoundException('Reservation not found');
    if (res.status !== 'CONFIRMED') {
      throw new BadRequestException('Reservation not confirmed');
    }
    // Verifica si requestingUserId es user o mentor
    if (
      res.user.id !== requestingUserId &&
      res.mentor.id !== requestingUserId
    ) {
      throw new BadRequestException('No access to this reservation');
    }
    // canal = res.agoraChannel
    const userToken = this.generateAgoraToken(res.agoraChannel, requestingUserId, RtcRole.PUBLISHER);
    return {
      channelName: res.agoraChannel,
      token: userToken,
      expiration: 2 * 60 * 60 // 2h
    };
  }

  async completeReservation(resId: number): Promise<Reservation> {
    const res = await this.reservationRepo.findOne({ where: { id: resId } });
    if (!res) throw new NotFoundException('Reservation not found');
    res.status = 'COMPLETED';
    return this.reservationRepo.save(res);
  }
}
EOF
echo "[INFO] Creado reservations.service.ts"

########################################
# 3. CONTROLLER: reservations.controller.ts
########################################
cat <<'EOF' > "$RESERVATIONS_DIR/reservations.controller.ts"
import { Controller, Post, Get, Patch, Param, Body, Req, UseGuards } from '@nestjs/common';
import { ReservationsService } from './reservations.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('reservations')
export class ReservationsController {
  constructor(private reservationsService: ReservationsService) {}

  // Crear reserva (ej. user crea)
  @UseGuards(JwtAuthGuard)
  @Post('create')
  async createReservation(@Body() body: any, @Req() req: any) {
    // body.mentorId, body.startTime, body.duration
    const userId = req.user.id; // user => id
    const { mentorId, startTime, duration } = body;
    return this.reservationsService.createReservation(userId, mentorId, new Date(startTime), duration);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id/confirm')
  async confirm(@Param('id') id: string) {
    return this.reservationsService.confirmReservation(Number(id));
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id/cancel')
  async cancel(@Param('id') id: string) {
    return this.reservationsService.cancelReservation(Number(id));
  }

  // Para obtener tokens de la videollamada
  @UseGuards(JwtAuthGuard)
  @Get(':id/call-token')
  async getCallToken(@Param('id') id: string, @Req() req: any) {
    return this.reservationsService.getCallTokens(Number(id), req.user.id);
  }

  // Marcar como completada
  @UseGuards(JwtAuthGuard)
  @Patch(':id/complete')
  async complete(@Param('id') id: string) {
    return this.reservationsService.completeReservation(Number(id));
  }

  // obtener todas (ej. admin / test)
  @UseGuards(JwtAuthGuard)
  @Get()
  async getAll() {
    return this.reservationsService.getAllReservations();
  }
}
EOF
echo "[INFO] Creado reservations.controller.ts"

########################################
# 4. MODULE: reservations.module.ts
########################################
cat <<'EOF' > "$RESERVATIONS_DIR/reservations.module.ts"
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Reservation } from './reservation.entity';
import { ReservationsService } from './reservations.service';
import { ReservationsController } from './reservations.controller';
import { ConfigModule } from '@nestjs/config';

@Module({
  imports: [
    ConfigModule,
    TypeOrmModule.forFeature([Reservation]),
  ],
  controllers: [ReservationsController],
  providers: [ReservationsService],
  exports: [ReservationsService]
})
export class ReservationsModule {}
EOF
echo "[INFO] Creado reservations.module.ts"

########################################
# 5. Ajustar el app.module.ts (opcional)
########################################
# Insertar "ReservationsModule" en app.module si no existe
APP_MODULE_PATH="${SRC_DIR}/app.module.ts"
if [ -f "$APP_MODULE_PATH" ]; then
  # Revisamos si ya está importado:
  if grep -q "ReservationsModule" "$APP_MODULE_PATH"; then
    echo "[INFO] app.module.ts ya contiene 'ReservationsModule'. No se modifica."
  else
    echo "[INFO] Insertando ReservationsModule en app.module.ts..."
    sed -i.bak "s%@Module({%@Module({\
  imports: [ ReservationsModule ],%g" "$APP_MODULE_PATH"
    # Nota: esto es un sed ingenuo que inserta "imports: [ ReservationsModule ]," justo tras la primera ocurrencia de @Module({
    # Ajusta o hazlo manual si tu app.module usa un estilo distinto.
    
    # También inserta import { ReservationsModule } from ...
    if ! grep -q "import { ReservationsModule" "$APP_MODULE_PATH"; then
      sed -i.bak "1i import { ReservationsModule } from './modules/reservations/reservations.module';" "$APP_MODULE_PATH"
    fi
  fi
else
  echo "[WARN] No se encontró app.module.ts. Agrega manualmente: 'ReservationsModule'."
fi

########################################
# Mensaje final
########################################
echo "[DONE] Script finalizado. Se han exportado los archivos del apartado 5 (Gestión de Reservas y Videollamadas)."
echo "Revisa la carpeta '${RESERVATIONS_DIR}' para ver 'reservation.entity.ts', 'reservations.service.ts', etc."
echo "Si sed no funcionó bien en app.module.ts, edítalo manualmente para añadir 'ReservationsModule' en imports."
