# Dialoom Backend Avanzado

Este proyecto crea un **backend** completo para Dialoom con las siguientes funcionalidades:

1. **Autenticación con Roles (superadmin, admin, host, user)** con JWT.
2. **Gestión de Usuarios** (registro, login, perfil), hosts y su disponibilidad.
3. **Gamificación** con badges, niveles, ranking, sumando puntos por acciones.
4. **Multi-idioma** (carpeta i18n con JSON para ES, EN, CA, DE, FR, NO, DA, IT, PL, NL).
5. **Soporte/Tickets** para que usuarios abran incidencias.
6. **Reservas** con notificaciones push (Firebase) y retención de comisiones en pagos Stripe (Dialoom Commission + IVA).
7. **Videollamadas** con Agora (generación de token RTC).
8. **Panel superadmin** con rutas admin para ver usuarios, cambiar roles, etc.
9. **Despliegue** via Docker + Nginx, con scripts de BD en `database/`.

## Uso

```bash
cp .env.example .env
# Ajustar credenciales e integraciones
npm install
docker-compose up -d
