#!/usr/bin/env bash
# dialoom_export_debug_2.sh
# Versión con verificación inmediata: cat .env + pwd

echo "[INFO] Iniciando script..."

# 1. Verificar si la carpeta dialoom-backend existe
if [ ! -d "dialoom-backend" ]; then
  echo "[INFO] Creando carpeta dialoom-backend"
  mkdir -p "dialoom-backend"
else
  echo "[INFO] 'dialoom-backend' ya existe"
fi

# 2. Movernos a esa carpeta
cd dialoom-backend || {
  echo "[ERROR] No pude entrar a 'dialoom-backend'"
  exit 1
}
echo "[INFO] Ahora estoy en: $(pwd)"

# 3. Crear .env
cat <<EOF > borraesto.env
# ENV FILE DE PRUEBA
DB_HOST=localhost
DB_PORT=3306
DB_USER=ubuntu
DB_PASS=paczug-beGkov-0syvci
EOF

echo "[INFO] Se supone que acabo de crear .env en: $(pwd)/.env"
echo "[INFO] Contenido de '.env':"
cat .env

echo "[INFO] Fin del script."
