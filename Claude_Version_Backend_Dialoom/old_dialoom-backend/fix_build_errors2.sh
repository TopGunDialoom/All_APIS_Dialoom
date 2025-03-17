#!/bin/bash

# Script para corregir errores de TypeScript en Dialoom Backend
# Autor: Claude
# Fecha: March 16, 2025

echo "=========================================================="
echo "Iniciando corrección de errores de TypeScript en Dialoom..."
echo "=========================================================="

# Directorio de trabajo
WORKDIR="/var/www/vhosts/core.dialoom.com/httpdocs"
cd $WORKDIR

# Crear directorio de backups si no existe
BACKUP_DIR="$WORKDIR/ts-error-backups-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR
echo "✓ Creado directorio de backups en: $BACKUP_DIR"

# 1. Corregir public.guard.ts
echo "Corrigiendo src/common/guards/public.guard.ts..."
cp src/common/guards/public.guard.ts "$BACKUP_DIR/public.guard.ts.bak"

cat > src/common/guards/public.guard.ts << 'EOL'
import { SetMetadata } from '@nestjs/common';
import { CanActivate, ExecutionContext, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Observable } from 'rxjs';

export const IS_PUBLIC_KEY = 'isPublic';
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);

@Injectable()
export class PublicGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(
    context: ExecutionContext,
  ): boolean | Promise<boolean> | Observable<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    
    return isPublic === true;
  }
}
EOL
echo "✓ Corregido archivo public.guard.ts"

# 2. Corregir admin.service.ts
echo "Corrigiendo src/modules/admin/admin.service.ts..."
cp src/modules/admin/admin.service.ts "$BACKUP_DIR/admin.service.ts.bak"

# Eliminar la duplicación de importación usando sed
sed -i '/^import { Repository } from/d' src/modules/admin/admin.service.ts
echo "✓ Corregido import duplicado en admin.service.ts"

# 3. Corregir i18n.service.ts
echo "Corrigiendo src/modules/i18n/i18n.service.ts..."
cp src/modules/i18n/i18n.service.ts "$BACKUP_DIR/i18n.service.ts.bak"

# Buscar y reemplazar la línea problemática
sed -i 's/sectionStack.push(currentSection\[sectionStack\[sectionStack.length - 1\]\]);/const key = sectionStack\[sectionStack.length - 1\];\n                  if (typeof key === "string" \&\& key in currentSection) {\n                    sectionStack.push(currentSection\[key\]);\n                  }/' src/modules/i18n/i18n.service.ts
echo "✓ Corregido error de tipos en i18n.service.ts"

# 4. Corregir payments.controller.ts
echo "Corrigiendo src/modules/payments/payments.controller.ts..."
cp src/modules/payments/payments.controller.ts "$BACKUP_DIR/payments.controller.ts.bak"

# Agregar interface PaymentIntent al principio del archivo
sed -i '1s/^/interface PaymentIntent {\n  id: string;\n  [key: string]: any;\n}\n\n/' src/modules/payments/payments.controller.ts

# Reemplazar la línea problemática
sed -i 's/paymentIntent.id/(paymentIntent as PaymentIntent).id/g' src/modules/payments/payments.controller.ts
echo "✓ Corregido error de tipo en payments.controller.ts"

echo "=========================================================="
echo "Correcciones completadas. Intenta ejecutar npm run build"
echo "Backups guardados en: $BACKUP_DIR"
echo "=========================================================="

echo "Ejecutando npm run build para verificar correcciones..."
npm run build

if [ $? -eq 0 ]; then
  echo "✅ ¡Compilación exitosa! Errores de TypeScript corregidos."
else
  echo "❌ La compilación aún tiene errores. Revisa el resultado."
fi
