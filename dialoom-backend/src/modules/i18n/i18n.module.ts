import { Module, Global } from '@nestjs/common';
import { I18nService } from './i18n.service';

/**
 * Módulo que gestiona la carga de archivos de traducción y
 * expone un servicio para localización de textos.
 * En un futuro, podrías integrarlo con librerías especializadas o con base de datos.
 */
@Global() // Lo marcamos global si deseamos que se inyecte en toda la app
@Module({
  providers: [I18nService],
  exports: [I18nService],
})
export class I18nModule {}
