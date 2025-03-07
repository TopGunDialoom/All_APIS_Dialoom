# Dialoom Backend

Este repositorio contiene el **backend** de la plataforma **Dialoom**, un servicio que conecta a usuarios con mentores mediante sesiones de videollamada.  
El objetivo principal es gestionar la **autenticación**, la **lógica de reservas**, los **pagos** (Stripe), la **gamificación** (insignias y logros), y proveer un **panel de administración** para supervisar y configurar la plataforma.

## Características Destacadas

- **NestJS (Node.js + TypeScript):** Estructura modular y orientada a objetos que facilita la escalabilidad y el mantenimiento.
- **Videollamadas con Agora:** Generación de tokens de acceso seguros para sesiones en tiempo real con alta calidad de audio y video.
- **Sistema de Pagos Integrado (Stripe):** Retención de comisiones (p. ej. 10% + IVA) y pago diferido a los mentores mediante Stripe Connect.
- **Autenticación Robusta:**
  - JWT (JSON Web Tokens) para sesiones stateless.
  - Login Social (Google, Apple, Microsoft, Facebook).
  - 2FA (opcional) para mayor seguridad.
- **Gamificación y Engagement:** Insignias, puntos, niveles y rankings para fomentar la participación activa.
- **Moderación y Reportes:** Los usuarios pueden reportar incidentes; el panel admin gestiona bloqueos, advertencias y acciones de seguridad.
- **Notificaciones Multicanal:** Emails transaccionales (SendGrid), notificaciones push (Firebase Cloud Messaging) y mensajería (WhatsApp/SMS) para recordatorios críticos.
- **Panel de Administración:** Permite ver estadísticas, gestionar usuarios/mentores, reservas y pagos, configurar comisiones y reglas globales.
- **Multidioma y Accesibilidad (WCAG 2.1):** Textos en varios idiomas (JSON/YAML) y diseño enfocado en la inclusión.

## Requisitos Previos

1. **Node.js** (versión 14+ o 16+)
2. **Docker** y **Docker Compose** (para desplegar contenedores)
3. **PostgreSQL** (si no lo ejecutas en contenedor, necesitas la DB instalada)
4. **Redis** (para caché y optimizaciones; también puede ir en contenedor)
5. **Stripe** (cuenta activa para procesar pagos, incl. claves API)
6. **Agora** (cuenta para videollamadas, incl. App ID y App Certificate)

## Configuración de Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto con las siguientes variables (ejemplo):

Ejemplo de .env

PORT=3000
DATABASE_URL=postgres://usuario:password@host:5432/dialoomdb
REDIS_HOST=localhost
REDIS_PORT=6379

STRIPE_SECRET_KEY=sk_test_***********
AGORA_APP_ID=***********
AGORA_APP_CERTIFICATE=***********
SENDGRID_API_KEY=***********
JWT_SECRET=***********

*(Ajusta nombres y valores según tu infraestructura.)*

## Instalación y Ejecución (Local sin Docker)

1. **Clona** el repositorio:
   ```bash
   git clone https://github.com/TopGunDialoom/dialoom-backend.git
   cd dialoom-backend

	2.	Instala dependencias:

npm install


	3.	Configura el archivo .env (ver sección anterior).
	4.	Inicia la aplicación:

npm run start:dev


	5.	Accede a la API en http://localhost:3000 (o el puerto definido en .env).

Despliegue con Docker
	1.	Asegúrate de tener Docker y Docker Compose instalados.
	2.	Clona el repositorio y ubícate en la carpeta raíz.
	3.	Crea tu archivo .env con las credenciales.
	4.	Ejecuta:

docker-compose up -d

Esto levantará el contenedor del backend y (opcionalmente) contenedores para PostgreSQL y Redis, si están configurados en el docker-compose.yml.

	5.	Comprueba que el servicio está corriendo en http://localhost:3000.

Estructura del Proyecto

dialoom-backend/
  ├── src/
  │   ├── app.module.ts         # Módulo raíz
  │   ├── main.ts               # Punto de entrada NestJS
  │   ├── modules/
  │   │   ├── auth/             # Autenticación (JWT, 2FA, login social)
  │   │   ├── users/            # Usuarios (clientes) y Hosts
  │   │   ├── reservations/     # Lógica de reservas
  │   │   ├── payments/         # Integración Stripe
  │   │   ├── gamification/     # Insignias, puntos, etc.
  │   │   ├── moderation/       # Reportes y acciones admin
  │   │   └── notifications/    # Emails, push, SMS
  │   └── ...otros
  ├── test/                     # Pruebas unitarias
  ├── docker-compose.yml
  ├── package.json
  ├── .env.example              # Ejemplo de variables de entorno
  └── README.md

Uso Básico
	•	Autenticación y Sesiones:
Envía el token JWT en la cabecera Authorization: Bearer <token> en cada petición protegida.
	•	Reservas:
	•	POST /reservations para crear una nueva reserva.
	•	GET /reservations/me para ver tus reservas.
	•	Videollamadas:
	•	El backend genera un token de Agora que el cliente usa para unirse al canal.
	•	Pagos (Stripe):
	•	El usuario ingresa su método de pago, el backend crea un PaymentIntent y retiene comisión.
	•	Gamificación:
	•	Cada acción (ej. completar sesión) suma puntos; si llegas a un umbral, se asigna una insignia.

Panel de Administración
	•	Ruta típica: http://<server>:3000/admin (o según configuración).
	•	Sólo superadministradores con credenciales de admin y (opcionalmente) 2FA pueden acceder.
	•	Permite visualizar usuarios/hosts, reservas, reportes, pagos y modificar configuraciones globales (comisión, políticas, etc.).

Contribución
	•	Pull Requests y Issues son bienvenidos para reportar bugs o proponer mejoras.
	•	Siéntete libre de abrir discusiones sobre nuevas funcionalidades, siempre alineadas con la visión de la plataforma.

# Dialoom Backend

Este repositorio contiene el **backend** de la plataforma **Dialoom**, un servicio que conecta a usuarios con mentores mediante sesiones de videollamada.  
El objetivo principal es gestionar la **autenticación**, la **lógica de reservas**, los **pagos** (Stripe), la **gamificación** (insignias y logros), y proveer un **panel de administración** para supervisar y configurar la plataforma.

## Características Destacadas

- **NestJS (Node.js + TypeScript):** Estructura modular y orientada a objetos que facilita la escalabilidad y el mantenimiento.
- **Videollamadas con Agora:** Generación de tokens de acceso seguros para sesiones en tiempo real con alta calidad de audio y video.
- **Sistema de Pagos Integrado (Stripe):** Retención de comisiones (p. ej. 10% + IVA) y pago diferido a los mentores mediante Stripe Connect.
- **Autenticación Robusta:**
  - JWT (JSON Web Tokens) para sesiones stateless.
  - Login Social (Google, Apple, Microsoft, Facebook).
  - 2FA (opcional) para mayor seguridad.
- **Gamificación y Engagement:** Insignias, puntos, niveles y rankings para fomentar la participación activa.
- **Moderación y Reportes:** Los usuarios pueden reportar incidentes; el panel admin gestiona bloqueos, advertencias y acciones de seguridad.
- **Notificaciones Multicanal:** Emails transaccionales (SendGrid), notificaciones push (Firebase Cloud Messaging) y mensajería (WhatsApp/SMS) para recordatorios críticos.
- **Panel de Administración:** Permite ver estadísticas, gestionar usuarios/mentores, reservas y pagos, configurar comisiones y reglas globales.
- **Multidioma y Accesibilidad (WCAG 2.1):** Textos en varios idiomas (JSON/YAML) y diseño enfocado en la inclusión.

## Requisitos Previos

1. **Node.js** (versión 14+ o 16+)
2. **Docker** y **Docker Compose** (para desplegar contenedores)
3. **PostgreSQL** (si no lo ejecutas en contenedor, necesitas la DB instalada)
4. **Redis** (para caché y optimizaciones; también puede ir en contenedor)
5. **Stripe** (cuenta activa para procesar pagos, incl. claves API)
6. **Agora** (cuenta para videollamadas, incl. App ID y App Certificate)

## Configuración de Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto con las siguientes variables (ejemplo):

Ejemplo de .env

PORT=3000
DATABASE_URL=postgres://usuario:password@host:5432/dialoomdb
REDIS_HOST=localhost
REDIS_PORT=6379

STRIPE_SECRET_KEY=sk_test_***********
AGORA_APP_ID=***********
AGORA_APP_CERTIFICATE=***********
SENDGRID_API_KEY=***********
JWT_SECRET=***********

*(Ajusta nombres y valores según tu infraestructura.)*

## Instalación y Ejecución (Local sin Docker)

1. **Clona** el repositorio:
   ```bash
   git clone https://github.com/TopGunDialoom/dialoom-backend.git
   cd dialoom-backend

	2.	Instala dependencias:

npm install


	3.	Configura el archivo .env (ver sección anterior).
	4.	Inicia la aplicación:

npm run start:dev


	5.	Accede a la API en http://localhost:3000 (o el puerto definido en .env).

Despliegue con Docker
	1.	Asegúrate de tener Docker y Docker Compose instalados.
	2.	Clona el repositorio y ubícate en la carpeta raíz.
	3.	Crea tu archivo .env con las credenciales.
	4.	Ejecuta:

docker-compose up -d

Esto levantará el contenedor del backend y (opcionalmente) contenedores para PostgreSQL y Redis, si están configurados en el docker-compose.yml.

	5.	Comprueba que el servicio está corriendo en http://localhost:3000.

Estructura del Proyecto

dialoom-backend/
  ├── src/
  │   ├── app.module.ts         # Módulo raíz
  │   ├── main.ts               # Punto de entrada NestJS
  │   ├── modules/
  │   │   ├── auth/             # Autenticación (JWT, 2FA, login social)
  │   │   ├── users/            # Usuarios (clientes) y Hosts
  │   │   ├── reservations/     # Lógica de reservas
  │   │   ├── payments/         # Integración Stripe
  │   │   ├── gamification/     # Insignias, puntos, etc.
  │   │   ├── moderation/       # Reportes y acciones admin
  │   │   └── notifications/    # Emails, push, SMS
  │   └── ...otros
  ├── test/                     # Pruebas unitarias
  ├── docker-compose.yml
  ├── package.json
  ├── .env.example              # Ejemplo de variables de entorno
  └── README.md

Uso Básico
	•	Autenticación y Sesiones:
Envía el token JWT en la cabecera Authorization: Bearer <token> en cada petición protegida.
	•	Reservas:
	•	POST /reservations para crear una nueva reserva.
	•	GET /reservations/me para ver tus reservas.
	•	Videollamadas:
	•	El backend genera un token de Agora que el cliente usa para unirse al canal.
	•	Pagos (Stripe):
	•	El usuario ingresa su método de pago, el backend crea un PaymentIntent y retiene comisión.
	•	Gamificación:
	•	Cada acción (ej. completar sesión) suma puntos; si llegas a un umbral, se asigna una insignia.

Panel de Administración
	•	Ruta típica: http://<server>:3000/admin (o según configuración).
	•	Sólo superadministradores con credenciales de admin y (opcionalmente) 2FA pueden acceder.
	•	Permite visualizar usuarios/hosts, reservas, reportes, pagos y modificar configuraciones globales (comisión, políticas, etc.).

Contribución
	•	Pull Requests y Issues son bienvenidos para reportar bugs o proponer mejoras.
	•	Siéntete libre de abrir discusiones sobre nuevas funcionalidades, siempre alineadas con la visión de la plataforma.

DEPENDENCIAS
dialoom-backend@1.0.0 /var/www/vhosts/core.dialoom.com/httpdocs/dialoom-backend
├── @nestjs/cli@9.5.0
├── @nestjs/common@9.4.3
├── @nestjs/config@2.3.4
├── @nestjs/core@9.4.3
├── @nestjs/jwt@9.0.0
├── @nestjs/passport@9.0.3
├── @nestjs/platform-express@9.4.3
├── @nestjs/schematics@9.2.0
├── @nestjs/typeorm@9.0.1
├── @sendgrid/mail@7.7.0
├── @types/bcrypt@5.0.2
├── @types/express@4.17.21
├── @types/jest@28.1.8
├── @types/node@18.19.79
├── @types/passport-facebook@3.0.3
├── @types/passport-google-oauth20@2.0.16
├── @types/passport-jwt@3.0.13
├── @types/passport-microsoft@1.0.3
├── @types/redis@4.0.11
├── @types/socket.io@3.0.2
├── @types/stripe@8.0.416
├── @typescript-eslint/eslint-plugin@5.62.0
├── @typescript-eslint/parser@5.62.0
├── agora-access-token@2.0.4
├── bcrypt@5.1.1
├── class-transformer@0.5.1
├── class-validator@0.14.1
├── eslint@8.57.1
├── firebase-admin@11.11.1
├── helmet@6.2.0
├── ioredis@5.6.0
├── jest@28.1.3
├── passport-apple@2.0.2
├── passport-facebook@3.0.0
├── passport-google-oauth20@2.0.0
├── passport-jwt@4.0.1
├── passport-microsoft@1.1.0
├── passport@0.6.0
├── redis@4.7.0
├── reflect-metadata@0.1.14
├── rxjs@7.8.2
├── stripe@11.18.0
├── ts-jest@28.0.8
├── ts-loader@9.5.2
├── twilio@3.84.1
├── typeorm@0.3.21
└── typescript@4.9.5

Licencia

“All Rights Reserved”
Este proyecto es de uso privado y propietario de la plataforma Dialoom, de Marc Garcia Garcia.
Todos los derechos reservados. No se permite su uso, copia o distribución sin autorización expresa.

Dialoom: Conectamos usuarios con mentores expertos de forma segura, práctica y escalable. ¡Gracias por tu interés en nuestro backend!

Licencia

“Free Use”
Este proyecto es de uso público y propietario de la plataforma Dialoom, de Marc Garcia Garcia. Acceso libre para ChatGPT y análisis permitido.
Todos los derechos reservados. No se permite su uso, copia o distribución sin autorización expresa.

Dialoom: Conectamos usuarios con mentores expertos de forma segura, práctica y escalable. ¡Gracias por tu interés en nuestro backend!
