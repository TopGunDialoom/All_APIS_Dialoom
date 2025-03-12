#!/usr/bin/env bash
# =============================================================================
# dialoom_export_scalability12.sh
# Script para exportar el apartado 12: "Escalabilidad y Crecimiento" - Dialoom
# =============================================================================
set -e

echo "[INFO] Iniciando script de exportación (Apartado 12: Escalabilidad y Crecimiento)..."

# 1) Verificar carpeta dialoom-backend
if [ -d "dialoom-backend" ]; then
  echo "[INFO] Directorio 'dialoom-backend' detectado."
else
  echo "[INFO] Creando 'dialoom-backend' pues no existe..."
  mkdir dialoom-backend
fi

cd dialoom-backend

# 2) Crear carpeta src/modules/scalability
echo "[INFO] Creando src/modules/scalability..."
mkdir -p src/modules/scalability

# ----------------------------------------------------------------------------
# 3) Crear scalability.module.ts
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/scalability/scalability.module.ts
import { Module } from '@nestjs/common';
import { GrowthService } from './services/growth.service';

/**
 * Módulo para alojar lógicas de escalabilidad, crecimiento,
 * microservicios y configuraciones de orquestación si se desea.
 *
 * Por ahora, sólo inyecta GrowthService con configuraciones
 * y directrices de escalado.
 */
@Module({
  providers: [GrowthService],
  exports: [GrowthService],
})
export class ScalabilityModule {}
EOF

# ----------------------------------------------------------------------------
# 4) Crear growth.service.ts
# ----------------------------------------------------------------------------
mkdir -p src/modules/scalability/services
cat <<'EOF' > src/modules/scalability/services/growth.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

/**
 * GrowthService - ejemplifica parámetros y lógicas relacionados
 * con la escalabilidad y despliegue multi-instancia.
 */
@Injectable()
export class GrowthService {
  private readonly logger = new Logger(GrowthService.name);
  private concurrency: number;
  private scalingStrategy: string;

  constructor(private configService: ConfigService) {
    // Ejemplo de parámetros:
    this.concurrency = Number(this.configService.get<string>('DIALOOM_MAX_WORKERS') || '4');
    this.scalingStrategy = this.configService.get<string>('SCALING_STRATEGY') || 'horizontal';
    this.logger.log(`GrowthService init => concurrency=${this.concurrency}, strategy=${this.scalingStrategy}`);
  }

  getConcurrency(): number {
    return this.concurrency;
  }

  getScalingStrategy(): string {
    return this.scalingStrategy;
  }

  /**
   * Podrías expandir con lógicas para:
   * - Microservicios (descubrir nodos, etc.)
   * - Cache warm-up (precalentar Redis)
   * - Manejo de colas en RabbitMQ / SQS
   * - Programar escalado auto
   */
  manageScaling() {
    this.logger.debug('manageScaling() => Manejando estrategia de escalado...');
    // implementa la lógica concreta si lo requieres
  }
}
EOF

# ----------------------------------------------------------------------------
# 5) Insertar ScalabilityModule en app.module.ts si no existe
# ----------------------------------------------------------------------------
if [ -f "src/app.module.ts" ]; then
  if grep -q "ScalabilityModule" src/app.module.ts; then
    echo "[INFO] ScalabilityModule ya se encuentra en app.module.ts, no se modifica."
  else
    echo "[INFO] Insertando ScalabilityModule en app.module.ts"
    sed -i.bak "/^import.*GamificationModule.*/a import { ScalabilityModule } from './modules/scalability/scalability.module';" src/app.module.ts || true
    sed -i.bak "s/\(imports: *\[[^]]*\)/\1,\n    ScalabilityModule/" src/app.module.ts || true
  fi
else
  echo "[WARN] app.module.ts no encontrado; no insertamos ScalabilityModule automáticamente."
fi

# ----------------------------------------------------------------------------
# 6) Insertar variables en .env
# ----------------------------------------------------------------------------
if [ -f ".env" ]; then
  echo "[INFO] Actualizando .env con DIALOOM_MAX_WORKERS, SCALING_STRATEGY"
  if ! grep -q "DIALOOM_MAX_WORKERS=" .env; then
    echo "DIALOOM_MAX_WORKERS=4" >> .env
  fi
  if ! grep -q "SCALING_STRATEGY=" .env; then
    echo "SCALING_STRATEGY=horizontal" >> .env
  fi
else
  echo "[INFO] Creando .env con DIALOOM_MAX_WORKERS y SCALING_STRATEGY"
  cat <<EOT > .env
DIALOOM_MAX_WORKERS=4
SCALING_STRATEGY=horizontal
EOT
fi

# ----------------------------------------------------------------------------
# 7) Añadir un README_scalability.md
# ----------------------------------------------------------------------------
cat <<'EOF' > README_scalability.md
# Escalabilidad y Crecimiento en Dialoom

Este documento describe lineamientos y configuraciones para escalar la plataforma Dialoom:

1. **Escalado Horizontal**
   - Lanzar múltiples instancias (contenedores Docker) de `dialoom-backend`.
   - Usar un load balancer (Nginx o AWS Lightsail LB) para distribuir tráfico.
   - Asegurarse de que la aplicación es stateless (basado en JWT, con Redis y DB compartida).

2. **Escalado Vertical**
   - Aumentar recursos del servidor (RAM/CPU).
   - Migrar a instancias más potentes en Lightsail si la carga lo requiere.

3. **Microservicios (Futuro)**
   - Separar ciertos módulos en servicios independientes (p.ej. notifications, chat, etc.).
   - Comunicar via colas (RabbitMQ/SQS) o HTTP internal load balancing.

4. **Automatización**
   - Pipeline CI/CD con contenedores. Cada push -> test -> build -> push a registry -> deploy.
   - Monitorizar logs (CloudWatch / Grafana) para detectar cuellos de botella.

5. **Monitorización**
   - Revisar métricas (CPU, mem, response times) con NestJS + prom-client o StatsD.
   - Integrar alertas (ej. Slack) si sube latencia de forma anormal.

6. **Consideraciones DB**
   - Si MySQL se satura, usar read replicas para queries intensivas.
   - Ajustar pool de conexiones typeORM. Revisar `.env` para DB pool max size.

7. **Referencia**
   - `GrowthService` (src/modules/scalability/services/growth.service.ts) maneja la concurrency y la
     estrategia. Podrías expandirlo con la lógica real de orquestación o integración en un orquestador
     (K8s).

## Variables en .env
- `DIALOOM_MAX_WORKERS`: número de procesos o hilos que se podrían usar.
- `SCALING_STRATEGY`: "horizontal" o "vertical" (o "auto").

Implementando estas pautas, Dialoom puede crecer de forma ágil y confiable.
EOF

echo "[DONE] Script finalizado (apartado 12: Escalabilidad y Crecimiento)."
echo "Se ha creado el módulo 'scalability' y ajustado .env con DIALOOM_MAX_WORKERS y SCALING_STRATEGY."
echo "Consulta README_scalability.md para más detalles."
