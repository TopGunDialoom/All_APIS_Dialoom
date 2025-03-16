#!/usr/bin/env bash

# Configurar el backend de Dialoom
echo "=== Configurando el backend de Dialoom ==="

# Crear archivo .env desde .env.example
if [ ! -f .env ]; then
  cp .env.example .env
  echo "Archivo .env creado desde .env.example. Por favor, actualiza las credenciales según sea necesario."
fi

# Instalar dependencias
echo "Instalando dependencias..."
npm install

# Solicitar iniciar la aplicación
echo ""
echo "Configuración completa. Para iniciar la aplicación en modo desarrollo, ejecuta:"
echo "npm run start:dev"
echo ""
echo "Para compilar la aplicación para producción:"
echo "npm run build"
echo ""
echo "Para iniciar en modo producción:"
echo "npm run start:prod"
