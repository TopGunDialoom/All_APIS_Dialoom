#!/bin/bash

# Script para corregir errores adicionales de TypeScript en Dialoom Backend
# Autor: Claude
# Fecha: March 16, 2025

echo "=========================================================="
echo "Iniciando corrección de errores adicionales de TypeScript en Dialoom..."
echo "=========================================================="

# Directorio de trabajo
WORKDIR="/var/www/vhosts/core.dialoom.com/httpdocs"
cd $WORKDIR

# Crear directorio de backups si no existe
BACKUP_DIR="$WORKDIR/ts-error-backups-v2-$(date +%Y%m%d-%H%M%S)"
mkdir -p $BACKUP_DIR
echo "✓ Creado directorio de backups en: $BACKUP_DIR"

# 1. Corregir admin.service.ts - eliminar las importaciones duplicadas
echo "Corrigiendo src/modules/admin/admin.service.ts..."
cp src/modules/admin/admin.service.ts "$BACKUP_DIR/admin.service.ts.bak"

# Eliminar la primera línea si contiene una importación de typeorm
sed -i '1 {/^import.*from.*typeorm.*/d}' src/modules/admin/admin.service.ts
echo "✓ Eliminada importación duplicada en admin.service.ts"

# 2. Corregir payments.controller.ts
echo "Corrigiendo src/modules/payments/payments.controller.ts..."
cp src/modules/payments/payments.controller.ts "$BACKUP_DIR/payments.controller.ts.bak"

# Listar el contenido del archivo para depuración
echo "Contenido de la línea problemática (135) antes de la corrección:"
sed -n '135p' src/modules/payments/payments.controller.ts

# Reemplazar la línea problemática con una versión corregida
sed -i '135s/if (pi await this.paymentsService.handlePaymentIntentSucceeded((paymentIntent as PaymentIntent).id);await this.paymentsService.handlePaymentIntentSucceeded((paymentIntent as PaymentIntent).id); pi.id) {/if (paymentIntent && (paymentIntent as PaymentIntent).id) {\n            await this.paymentsService.handlePaymentIntentSucceeded((paymentIntent as PaymentIntent).id);/' src/modules/payments/payments.controller.ts

# Verificar la corrección
echo "Contenido de la línea después de la corrección:"
sed -n '135,136p' src/modules/payments/payments.controller.ts

echo "=========================================================="
echo "Correcciones adicionales completadas. Ejecutando build..."
echo "Backups guardados en: $BACKUP_DIR"
echo "=========================================================="

# Ejecutar build para verificar las correcciones
npm run build

if [ $? -eq 0 ]; then
  echo "✅ ¡Compilación exitosa! Errores de TypeScript corregidos."
else
  echo "❌ La compilación aún tiene errores. Revisemos el resultado."
  echo ""
  echo "Si el error persiste en payments.controller.ts, podemos necesitar editar manualmente ese archivo."
  echo "Sugerencia: abre el archivo con 'nano src/modules/payments/payments.controller.ts'"
  echo "Localiza la línea problemática (cerca de la 135) y edítala manualmente para tener una estructura correcta:"
  echo ""
  echo "if (paymentIntent && (paymentIntent as PaymentIntent).id) {"
  echo "  await this.paymentsService.handlePaymentIntentSucceeded((paymentIntent as PaymentIntent).id);"
  echo "}"
  echo ""
fi
