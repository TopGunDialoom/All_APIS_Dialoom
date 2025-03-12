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
