#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# dialoom_export_debug.sh
# -----------------------------------------------------------------------------
# Este script crea la carpeta 'dialoom-backend' (si no existe),
# entra en ella y genera una estructura mínima, incluyendo el .env
# en la raíz de 'dialoom-backend', con tus credenciales.
#
# Además, muestra mensajes de depuración y comprueba si .env se crea.
# -----------------------------------------------------------------------------

echo "[INFO] Comenzando script de exportación con debug..."

# 1. Crear carpeta dialoom-backend si no existe
if [ ! -d "dialoom-backend" ]; then
  echo "[INFO] Creando carpeta 'dialoom-backend'..."
  mkdir -p "dialoom-backend"
else
  echo "[INFO] La carpeta 'dialoom-backend' ya existe."
fi

# 2. Movernos a 'dialoom-backend'
echo "[INFO] Entrando en carpeta 'dialoom-backend'..."
cd "dialoom-backend" || {
  echo "[ERROR] No se pudo entrar a la carpeta 'dialoom-backend'." 1>&2
  exit 1
}

# 3. Generar un .env
#    Aquí definimos la base de datos en MySQL, Stripe, Agora, etc.
#    y omitimos lo que no quieras integrar todavía (Firebase, Twilio, etc.)
echo "[INFO] Creando .env en $(pwd)..."
cat <<EOF > .env
# ------------------------------------------------------------------------------
# DIALOOM .env
# Archivo de configuración de entorno.
# ------------------------------------------------------------------------------
# MySQL
DB_HOST=localhost
DB_PORT=3306
DB_USER=ubuntu
DB_PASS=paczug-beGkov-0syvci
DB_NAME=coreadmin

# Stripe
STRIPE_SECRET_KEY=pk_live_51HP3mrKXQqKHMLt...

# Agora
AGORA_APP_ID=d553a1e4f2434064951d6ef117d32750
AGORA_APP_CERT=59d23aa57a204028959f93e06e0ff204

# Redis
REDIS_HOST=127.0.0.1

# Correo en Plesk:
#  (Se asume que usarás sendmail o mail del server local.
#   No definimos credenciales SMTP aquí si no lo deseas.)

# ------------------------------------------------------------------------------
# Ajusta estas variables según tu infraestructura real.
# ------------------------------------------------------------------------------
EOF

# 4. Confirmar si .env se ha creado
if [ -f ".env" ]; then
  echo "[INFO] .env ha sido creado con éxito en $(pwd)."
else
  echo "[ERROR] .env NO se ha creado. ¿Hubo algún error de permisos?"
  ls -la
  exit 1
fi

# 5. Podemos crear un package.json minimal, o re-crear la estructura deseada
#    Si ya tienes package.json en la raíz, puedes omitir. Como ejemplo:
echo "[INFO] Creando package.json minimal (si no existe) con dependencias..."
if [ ! -f "package.json" ]; then
  cat <<EOF > package.json
{
  "name": "dialoom-backend",
  "version": "1.0.0",
  "description": "Backend NestJS for Dialoom platform (with debug script)",
  "scripts": {
    "start": "nest start",
    "start:dev": "nest start --watch",
    "build": "nest build",
    "start:prod": "node dist/main.js"
  },
  "dependencies": {
    "@nestjs/common": "^9.0.0",
    "@nestjs/config": "^2.2.0",
    "@nestjs/core": "^9.0.0",
    "@nestjs/jwt": "^9.0.0",
    "@nestjs/passport": "^9.0.0",
    "@nestjs/platform-express": "^9.0.0",
    "@nestjs/typeorm": "^9.0.0",
    "agora-access-token": "^2.0.0",
    "bcrypt": "^5.1.0",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.0",
    "helmet": "^6.0.0",
    "ioredis": "^5.2.0",
    "passport": "^0.6.0",
    "redis": "^4.0.11",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.0.0",
    "stripe": "^11.0.0",
    "typeorm": "^0.3.12"
  },
  "devDependencies": {
    "@nestjs/cli": "^9.0.0",
    "@nestjs/schematics": "^9.0.0",
    "@types/bcrypt": "^5.0.0",
    "@types/node": "^18.0.0",
    "@typescript-eslint/eslint-plugin": "^5.0.0",
    "@typescript-eslint/parser": "^5.0.0",
    "eslint": "^8.0.0",
    "typescript": "^4.6.4"
  }
}
EOF
  echo "[INFO] package.json creado."
else
  echo "[INFO] package.json ya existe. No se sobrescribe."
fi

echo "[INFO] Estructura básica generada. Revisa la carpeta para confirmar."

# 6. Mensaje final
echo "[INFO] Para verificar, haz: cd dialoom-backend && ls -la"
echo "[INFO] Si .env está presente, la exportación se ha realizado satisfactoriamente."
echo "[DONE] Script finalizado."
