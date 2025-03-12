#!/usr/bin/env bash
# =============================================================================
# dialoom_export_i18n11.sh
# Script para exportar el apartado 11: "Multidioma y Accesibilidad" - Dialoom
# =============================================================================
set -e

echo "[INFO] Iniciando script de exportación (Apartado 11: Multidioma y Accesibilidad)..."

# 1) Verificar carpeta dialoom-backend
if [ -d "dialoom-backend" ]; then
  echo "[INFO] Directorio 'dialoom-backend' detectado."
else
  echo "[INFO] Creando 'dialoom-backend' pues no existe..."
  mkdir dialoom-backend
fi

cd dialoom-backend

# 2) Crear subcarpeta para i18n module
echo "[INFO] Creando src/modules/i18n..."
mkdir -p src/modules/i18n
mkdir -p src/modules/i18n/locales

# ----------------------------------------------------------------------------
# 3) i18n.module.ts
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/i18n/i18n.module.ts
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
EOF

# ----------------------------------------------------------------------------
# 4) i18n.service.ts
# ----------------------------------------------------------------------------
cat <<'EOF' > src/modules/i18n/i18n.service.ts
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
EOF

# ----------------------------------------------------------------------------
# 5) Generar algunos archivos locales (en, es, etc.)
# ----------------------------------------------------------------------------
echo "[INFO] Creando archivos JSON de ejemplo en src/modules/i18n/locales..."
cat <<'EOF' > src/modules/i18n/locales/en.json
{
  "general": {
    "hello": "Hello, welcome to Dialoom!"
  },
  "errors": {
    "not_found": "Resource not found.",
    "unauthorized": "You are not authorized."
  },
  "accessibility": {
    "mode_active": "Accessibility mode is currently active."
  }
}
EOF

cat <<'EOF' > src/modules/i18n/locales/es.json
{
  "general": {
    "hello": "¡Hola, bienvenido a Dialoom!"
  },
  "errors": {
    "not_found": "Recurso no encontrado.",
    "unauthorized": "No estás autorizado."
  },
  "accessibility": {
    "mode_active": "El modo de accesibilidad está activo."
  }
}
EOF

# ----------------------------------------------------------------------------
# 6) Accessibilidad: ej. guard o decorator de ejemplo
# ----------------------------------------------------------------------------
mkdir -p src/common/accessibility
cat <<'EOF' > src/common/accessibility/accessibility.guard.ts
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
EOF

# ----------------------------------------------------------------------------
# 7) Insertar I18nModule en app.module.ts si no existe
# ----------------------------------------------------------------------------
if [ -f "src/app.module.ts" ]; then
  if grep -q "I18nModule" src/app.module.ts; then
    echo "[INFO] I18nModule ya existe en app.module.ts, no se modifica."
  else
    echo "[INFO] Insertando I18nModule en app.module.ts"
    sed -i.bak "/^import.*ConfigModule.*/a import { I18nModule } from './modules/i18n/i18n.module';" src/app.module.ts || true
    sed -i.bak "s/\(imports: *\[[^]]*\)/\1,\n    I18nModule/" src/app.module.ts || true
  fi
else
  echo "[WARN] app.module.ts no encontrado; no insertamos I18nModule automáticamente."
fi

# ----------------------------------------------------------------------------
# 8) Ajustar .env con DEFAULT_LANG, ACCESSIBILITY_MODE
# ----------------------------------------------------------------------------
if [ -f ".env" ]; then
  echo "[INFO] Actualizando .env con DEFAULT_LANG y ACCESSIBILITY_MODE si no existen."
  if ! grep -q "DEFAULT_LANG=" .env; then
    echo "DEFAULT_LANG=en" >> .env
  fi
  if ! grep -q "ACCESSIBILITY_MODE=" .env; then
    echo "ACCESSIBILITY_MODE=false" >> .env
  fi
else
  echo "[INFO] Creando .env con DEFAULT_LANG y ACCESSIBILITY_MODE"
  cat <<EOT > .env
DEFAULT_LANG=en
ACCESSIBILITY_MODE=false
EOT
fi

echo "[DONE] Script finalizado para el apartado 11 (Multidioma y Accesibilidad)."
echo "Revisa src/modules/i18n/ y src/common/accessibility/ para ver los archivos generados."
