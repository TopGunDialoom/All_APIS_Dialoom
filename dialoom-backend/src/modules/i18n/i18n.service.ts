import { Injectable, Logger } from '@nestjs/common';
import * as fs from 'fs';
import * as path from 'path';

interface LocaleData {
  [key: string]: string | LocaleData;
}

/**
 * Servicio sencillo para cargar y leer archivos de traducciones en JSON o YAML.
 * En un futuro, podrías usar @nestjs/i18n o una librería más robusta.
 */
@Injectable()
export class I18nService {
  private readonly logger = new Logger(I18nService.name);
  private translations: Record<string, LocaleData> = {};
  private defaultLang: string = 'en';

  constructor() {
    // Carga inicial de locales
    this.loadLocales();
    this.logger.log('I18nService inicializado con locales disponibles');
  }

  private loadLocales() {
    const localesDir = path.join(__dirname, 'locales');
    // Asumimos que los .json están en i18n/locales/
    if (!fs.existsSync(localesDir)) {
      this.logger.warn(`No se encontró carpeta locales en: ${localesDir}`);
      return;
    }
    const files = fs.readdirSync(localesDir);
    files.forEach((file) => {
      if (file.endsWith('.json')) {
        const langCode = file.replace('.json', '');
        try {
          const filePath = path.join(localesDir, file);
          const content = fs.readFileSync(filePath, 'utf8');
          this.translations[langCode] = JSON.parse(content);
          this.logger.log(`Cargado locale '${langCode}' desde ${file}`);
        } catch (err) {
          this.logger.error(`Error cargando locale '${file}': ${err.message}`);
        }
      }
    });
  }

  public setDefaultLang(lang: string) {
    if (this.translations[lang]) {
      this.defaultLang = lang;
    } else {
      this.logger.warn(`El idioma ${lang} no existe. Se mantiene ${this.defaultLang}`);
    }
  }

  public translate(key: string, lang?: string): string {
    const selectedLang = lang && this.translations[lang] ? lang : this.defaultLang;
    const keys = key.split('.');
    let result: any = this.translations[selectedLang];

    for (const k of keys) {
      if (result && typeof result === 'object' && k in result) {
        result = result[k];
      } else {
        return key; // si no encuentra, retorna la key misma
      }
    }
    return typeof result === 'string' ? result : key;
  }
}
