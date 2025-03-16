cat > dialoom-backend-solution-fixed.sh << 'EOF'
#!/bin/bash

# Script para reconstruir completamente el backend de Dialoom
# Este script generará una estructura completa de proyecto NestJS desde cero

set -e  # Detener el script si ocurre algún error

# Colores para mejorar la legibilidad
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Función para manejo de errores
handle_error() {
  echo -e "${RED}Error en la línea $1${NC}"
  echo -e "${RED}Algo salió mal durante la ejecución del script. Por favor revise los mensajes de error anteriores.${NC}"
  exit 1
}

# Configurar trap para capturar errores
trap 'handle_error $LINENO' ERR

echo -e "${GREEN}=== Iniciando reconstrucción del backend de Dialoom ===${NC}"

# 1. Crear un nuevo proyecto NestJS y limpiar el directorio existente
echo -e "${YELLOW}Paso 1: Creando estructura base del proyecto${NC}"

# Verificar si existe el directorio dialoom-backend
if [ -d "dialoom-backend" ]; then
  echo "Haciendo backup del proyecto existente..."
  BACKUP_DIR="dialoom-backend-backup-$(date +%Y%m%d%H%M%S)"
  mv dialoom-backend "$BACKUP_DIR"
  echo "Backup creado en $BACKUP_DIR"
fi

# Crear estructura de directorios manualmente
mkdir -p dialoom-backend/src
cd dialoom-backend

# Crear package.json base
cat > package.json << 'EEOF'
{
  "name": "dialoom-backend",
  "version": "0.1.0",
  "description": "Backend para Dialoom",
  "author": "",
  "private": true,
  "license": "UNLICENSED",
  "scripts": {
    "build": "nest build",
    "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:debug": "node --inspect-brk -r tsconfig-paths/register -r ts-node/register node_modules/.bin/jest --runInBand",
    "test:e2e": "jest --config ./test/jest-e2e.json",
    "seed": "ts-node src/config/seed.ts"
  },
  "dependencies": {
    "@nestjs/common": "^10.0.0",
    "@nestjs/core": "^10.0.0",
    "@nestjs/platform-express": "^10.0.0",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.8.1"
  },
  "devDependencies": {
    "@nestjs/cli": "^10.0.0",
    "@nestjs/schematics": "^10.0.0",
    "@nestjs/testing": "^10.0.0",
    "@types/express": "^4.17.17",
    "@types/jest": "^29.5.2",
    "@types/node": "^20.3.1",
    "@types/supertest": "^2.0.12",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.42.0",
    "eslint-config-prettier": "^9.0.0",
    "eslint-plugin-prettier": "^5.0.0",
    "jest": "^29.5.0",
    "prettier": "^3.0.0",
    "source-map-support": "^0.5.21",
    "supertest": "^6.3.3",
    "ts-jest": "^29.1.0",
    "ts-loader": "^9.4.3",
    "ts-node": "^10.9.1",
    "tsconfig-paths": "^4.2.0",
    "typescript": "^5.1.3"
  },
  "jest": {
    "moduleFileExtensions": [
      "js",
      "json",
      "ts"
    ],
    "rootDir": "src",
    "testRegex": ".*\\.spec\\.ts$",
    "transform": {
      "^.+\\.(t|j)s$": "ts-jest"
    },
    "collectCoverageFrom": [
      "**/*.(t|j)s"
    ],
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  }
}
EEOF

# Crear tsconfig.json
cat > tsconfig.json << 'EEOF'
{
  "compilerOptions": {
    "module": "commonjs",
    "declaration": true,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "target": "ES2021",
    "sourceMap": true,
    "outDir": "./dist",
    "baseUrl": "./",
    "incremental": true,
    "skipLibCheck": true,
    "strictNullChecks": false,
    "noImplicitAny": false,
    "strictBindCallApply": false,
    "forceConsistentCasingInFileNames": false,
    "noFallthroughCasesInSwitch": false
  }
}
EEOF

# Crear .env
cat > .env << 'EEOF'
# Entorno
NODE_ENV=development
PORT=3000

# Base de datos
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=root
DB_NAME=dialoom

# JWT
JWT_SECRET=dialoom_secret_key_change_in_production
JWT_EXPIRATION=1d

# Stripe
STRIPE_SECRET_KEY=sk_test_your_stripe_key
EEOF

# Instalar dependencias
echo "Instalando dependencias base..."
npm install

# 2. Instalar dependencias necesarias con versiones compatibles
echo -e "${YELLOW}Paso 2: Instalando dependencias específicas${NC}"
npm install --save @nestjs/typeorm@10.0.1 typeorm@0.3.20 mysql2@3.9.1 bcrypt@5.1.1 class-validator@0.14.1 class-transformer@0.5.1 passport@0.7.0 passport-jwt@4.0.1 passport-local@1.0.0 @nestjs/passport@10.0.3 @nestjs/jwt@10.2.0 @nestjs/config@3.2.0 @nestjs/swagger@7.3.1 stripe@14.18.0 uuid@9.0.1 multer@1.4.5-lts.1 cors@2.8.5

echo "Instalando dependencias de desarrollo..."
npm install --save-dev @types/passport-jwt@4.0.1 @types/passport-local@1.0.38 @types/bcrypt@5.0.2 @types/multer@1.4.11 @types/uuid@9.0.8 @types/cors@2.8.17

# 3. Crear estructura de carpetas
echo -e "${YELLOW}Paso 3: Creando estructura del proyecto${NC}"

# Crear estructura de carpetas
mkdir -p src/config
mkdir -p src/common/decorators
mkdir -p src/common/guards
mkdir -p src/common/middleware
mkdir -p src/common/filters
mkdir -p src/common/interceptors
mkdir -p src/common/utils

# Módulos principales
mkdir -p src/modules/users
mkdir -p src/modules/auth
mkdir -p src/modules/roles
mkdir -p src/modules/bookings
mkdir -p src/modules/payments
mkdir -p src/modules/services
mkdir -p src/modules/notifications
mkdir -p src/modules/providers
mkdir -p src/modules/locations
mkdir -p src/modules/favorites
mkdir -p src/modules/gamification

# 4. Generar archivos base
echo -e "${YELLOW}Paso 4: Generando archivos de configuración${NC}"

# Archivo principal
cat > src/main.ts << 'EEOF'
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: ['error', 'warn', 'log', 'debug', 'verbose']
  });
  
  // Configuración global
  app.setGlobalPrefix('api');
  
  // Configuración de CORS
  app.enableCors({
    origin: process.env.CORS_ORIGIN || '*',
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    preflightContinue: false,
    optionsSuccessStatus: 204,
    credentials: true,
    allowedHeaders: 'Origin,X-Requested-With,Content-Type,Accept,Authorization',
  });
  
  // Pipes de validación global
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true,
    forbidNonWhitelisted: true,
    transformOptions: {
      enableImplicitConversion: true,
    },
  }));

  // Configuración de Swagger
  const config = new DocumentBuilder()
    .setTitle('Dialoom API')
    .setDescription('API para la plataforma Dialoom')
    .setVersion('1.0')
    .addBearerAuth()
    .addTag('auth', 'Endpoints de autenticación')
    .addTag('users', 'Endpoints de usuarios')
    .addTag('roles', 'Endpoints de roles')
    .addTag('bookings', 'Endpoints de reservas')
    .addTag('payments', 'Endpoints de pagos')
    .addTag('services', 'Endpoints de servicios')
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  // Iniciar servidor
  const port = process.env.PORT || 3000;
  await app.listen(port);
  
  const serverUrl = await app.getUrl();
  console.log(\`--------------------------------------------------\`);
  console.log(\`🚀 Aplicación corriendo en: \${serverUrl}\`);
  console.log(\`📚 Documentación API: \${serverUrl}/api/docs\`);
  console.log(\`--------------------------------------------------\`);
}
bootstrap();
EEOF

# Configuración de base de datos
cat > src/config/database.config.ts << 'EEOF'
import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import * as dotenv from 'dotenv';

dotenv.config();

export const databaseConfig: TypeOrmModuleOptions = {
  type: 'mysql',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT) || 3306,
  username: process.env.DB_USERNAME || 'root',
  password: process.env.DB_PASSWORD || 'root',
  database: process.env.DB_NAME || 'dialoom',
  entities: [__dirname + '/../**/*.entity{.ts,.js}'],
  synchronize: process.env.NODE_ENV !== 'production',
  logging: process.env.NODE_ENV === 'development',
  // Opciones adicionales para mejor rendimiento y seguridad
  charset: 'utf8mb4',
  timezone: 'Z', // UTC
  connectTimeout: 30000, // Aumentar tiempo de conexión para entornos lentos
  extra: {
    connectionLimit: 10, // Límite de conexiones simultáneas
  },
  // Verificar la conexión antes de ejecutar consultas
  keepConnectionAlive: true,
  // Opciones para migraciones
  migrations: [__dirname + '/../migrations/**/*{.ts,.js}'],
  migrationsTableName: 'migrations',
  migrationsRun: false, // No ejecutar migraciones automáticamente
};
EEOF

# Módulo principal de la aplicación
cat > src/app.module.ts << 'EEOF'
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import { databaseConfig } from './config/database.config';

@Module({
  imports: [
    // Configuración global
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    
    // Base de datos
    TypeOrmModule.forRoot(databaseConfig),
    
    // Módulos de la aplicación serán agregados aquí
  ],
})
export class AppModule {}
EEOF

# 5. Verificar conexión a MySQL y crear base de datos si es necesario
echo -e "${YELLOW}Paso 5: Verificando conexión a MySQL${NC}"

read -p "¿Deseas configurar automáticamente la base de datos MySQL ahora? (s/n): " configure_db

if [ "$configure_db" = "s" ] || [ "$configure_db" = "S" ]; then
  read -p "Host de MySQL (por defecto localhost): " db_host
  db_host=${db_host:-localhost}
  
  read -p "Puerto de MySQL (por defecto 3306): " db_port
  db_port=${db_port:-3306}
  
  read -p "Usuario de MySQL: " db_user
  
  read -sp "Contraseña de MySQL (no se mostrará): " db_pass
  echo ""
  
  read -p "Nombre de la base de datos (por defecto dialoom): " db_name
  db_name=${db_name:-dialoom}
  
  # Verificar conexión a MySQL
  echo "Verificando conexión a MySQL..."
  if command -v mysql &> /dev/null; then
    # Intentar conectar a MySQL
    if mysql -h "$db_host" -P "$db_port" -u "$db_user" --password="$db_pass" -e "SELECT 1" &> /dev/null; then
      echo "Conexión a MySQL exitosa."
      
      # Verificar si la base de datos existe, si no, crearla
      if ! mysql -h "$db_host" -P "$db_port" -u "$db_user" --password="$db_pass" -e "USE $db_name" &> /dev/null; then
        echo "La base de datos $db_name no existe. Creándola..."
        mysql -h "$db_host" -P "$db_port" -u "$db_user" --password="$db_pass" -e "CREATE DATABASE $db_name CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
        echo "Base de datos $db_name creada exitosamente."
      else
        echo "La base de datos $db_name ya existe."
      fi
      
      # Actualizar el archivo .env con los datos de conexión
      cat > .env << ENVEOF
# Entorno
NODE_ENV=development
PORT=3000

# Base de datos
DB_HOST=$db_host
DB_PORT=$db_port
DB_USERNAME=$db_user
DB_PASSWORD=$db_pass
DB_NAME=$db_name

# JWT
JWT_SECRET=dialoom_secret_key_change_in_production
JWT_EXPIRATION=1d

# Stripe
STRIPE_SECRET_KEY=sk_test_your_stripe_key
ENVEOF
      echo "Archivo .env actualizado con los datos de conexión."
    else
      echo -e "${RED}No se pudo conectar a MySQL. Verifica las credenciales e intenta nuevamente.${NC}"
      echo "El archivo .env deberá ser configurado manualmente."
    fi
  else
    echo -e "${YELLOW}El cliente MySQL no está instalado. No se pudo verificar la conexión.${NC}"
    echo "El archivo .env deberá ser configurado manualmente."
  fi
fi

echo -e "${GREEN}=== Paso inicial completado ====${NC}"
echo -e "La estructura básica ha sido creada y las dependencias instaladas correctamente."
echo -e "A continuación, deberás implementar los módulos específicos que necesitas."
echo -e ""
echo -e "Ahora puedes continuar con:"
echo -e "1. cd dialoom-backend"
echo -e "2. npm run start:dev"
echo -e ""
echo -e "La documentación API estará disponible en http://localhost:3000/api/docs"
EOF

chmod +x dialoom-backend-solution-fixed.sh
