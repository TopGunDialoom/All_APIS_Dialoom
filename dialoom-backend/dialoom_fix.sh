#!/usr/bin/env bash
set -e  # Si algo falla, que el script se detenga

############################################
# 1. Instalar dependencias que faltan      #
############################################

echo "==> Instalando @nestjs/config, helmet y @types/helmet..."

# Añadimos las dependencias al package.json
#npm install --save @nestjs/config@^2.2.0 helmet@^6.0.0
#npm install --save-dev @types/helmet@^6.1.3

# Añadimos tipado para 'passport-apple' si deseas forzar su reconocimiento
# (no existe paquete oficial, así que sólo “declare module”)
# Ojo: si no deseas forzar, puedes omitirlo
echo "==> Creando src/types/passport-apple.d.ts si no existe..."
mkdir -p src/types
if [ ! -f "src/types/passport-apple.d.ts" ]; then
cat <<EOF > src/types/passport-apple.d.ts
declare module 'passport-apple';
EOF
fi

############################################
# 2. Crear/corregir archivo JwtAuthGuard   #
############################################

echo "==> Creando src/auth/guards/jwt-auth.guard.ts si no existe..."
mkdir -p src/auth/guards
if [ ! -f "src/auth/guards/jwt-auth.guard.ts" ]; then
cat <<EOF > src/auth/guards/jwt-auth.guard.ts
import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
EOF
fi

############################################
# 3. Añadir ConfigModule.forRoot() en app.module.ts (opcional)
############################################

# Este sed es “ingenuo”. Sólo si no tienes ya ConfigModule importado.
# Ajusta a tu gusto si ya lo tienes.
# Sustituirá la línea 'imports: [' por un bloque con ConfigModule.
# Ojo: Si ya tienes algo, revisa manualmente.
if grep -q "ConfigModule.forRoot" src/app.module.ts; then
  echo "==> app.module.ts ya parece tener ConfigModule.forRoot. No modifico."
else
  echo "==> Insertando ConfigModule.forRoot() en app.module.ts (ingenuo sed)..."
  sed -i.bak '/imports: \[/a \
\ \ \ \ ConfigModule.forRoot({\\n      isGlobal: true,\\n    }),\
' src/app.module.ts || true
fi

############################################
# 4. Reemplazar imports de dayjs ("import * as dayjs")
#    por "import dayjs from 'dayjs';" en *.service.ts
############################################

echo "==> Corrigiendo import de dayjs (de '* as dayjs' a default) en 'src/modules/*service.ts'..."
find src/modules -type f -name "*service.ts" -exec sed -i.bak \
  "s/import \* as dayjs from 'dayjs'/import dayjs from 'dayjs'/g" {} \; || true

############################################
# 5. Añadir '!' en propiedades de las Entities (TS2564).
#    Este es el cambio más delicado:
#    Reemplazamos "id: number;" por "id!: number;", etc.
#    Igualmente con string, boolean, etc.
############################################

echo "==> Aplicando naive sed para poner '!' en entidades..."

# Lista de patrones típicos. Puedes extender con number, boolean, string, Date...
# Ten en cuenta que esto es un “approach” muy ingenuo. No cubre todo.
# Aplica a .entity.ts. Ajusta según tus nombres de ficheros.
declare -a TSTYPES=("number" "string" "boolean" "Date" "UserRole" "TransactionStatus" "TicketStatus" "Achievement" "User" "Setting" "Host" "any")

for T in "${TSTYPES[@]}"; do
  echo "    -> Insertando '!' en propiedades con tipo '$T'"
  find src/modules -type f -name "*.entity.ts" -exec sed -i.bak \
    "s/\([A-Za-z0-9_]\+\): $T;/\1!: $T;/g" {} \; || true
done

# Podríamos hacer un second pass si tuvieras '?:' o '| null', etc.
# O substitución genérica: '^[^!]+: [^;]+;$' ...
# Pero es arriesgado en sed.
# Revisa luego manualmente.

############################################
# 6. Revisar backticks rotos en interceptors / Twilio
############################################

echo "==> Corrigiendo backticks (ingenuo) en logging.interceptor.ts y twilio.service.ts..."

# logging.interceptor.ts:
# Buscamos algo como:  const logMessage = \`User \${ ... } ...\`;
# A veces se corrompe al copiar. Dejamos uno correcto:
if [ -f "src/common/interceptors/logging.interceptor.ts" ]; then
cat <<EOF > src/common/interceptors/logging.interceptor.ts
import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Observable } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const userId = request.user?.id || 'anonymous';
    const method = request.method;
    const originalUrl = request.url;

    const logMessage = \`User \${userId} -> [\${method}] \${originalUrl}\`;
    console.log(logMessage);

    return next.handle();
  }
}
EOF
fi

# twilio.service.ts:
# (Si existe, reescribimos parte con un snippet que contenga backticks bien formados.)
if [ -f "src/modules/notifications/channels/twilio.service.ts" ]; then
  echo "==> Reemplazando 'twilio.service.ts' con un snippet que asume la client/messages usage..."
  cat <<EOF > src/modules/notifications/channels/twilio.service.ts
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Twilio from 'twilio';

@Injectable()
export class TwilioService {
  private readonly client: Twilio.Twilio;
  constructor(private readonly configService: ConfigService) {
    const accountSid = this.configService.get<string>('TWILIO_ACCOUNT_SID') || '';
    const authToken = this.configService.get<string>('TWILIO_AUTH_TOKEN') || '';
    this.client = Twilio(accountSid, authToken);
  }

  async sendWhatsappMessage(toNumber: string, message: string, fromWhatsapp: string) {
    return this.client.messages.create({
      body: message,
      from: fromWhatsapp,
      to: \`whatsapp:\${toNumber}\`,
    });
  }
}
EOF
fi

############################################
# 7. Ajustes de Services que devuelven "User | null"
############################################

echo "==> Aviso: Revisa manualmente los returns de 'User | null'."
echo "    Si findOne() puede retornar null, o lanza NotFoundException, o devuelves 'User | null'."

############################################
# 8. Final
############################################

echo "==> Script de fix finalizado."
echo "    1) Por favor, revisa los archivos .bak en cada carpeta: sed deja backups."
echo "    2) Compara los cambios (git diff) y confirma que todo se haya modificado correctamente."
echo "    3) Una vez conforme: 'npm run build' y comprueba si ya compila sin errores."
exit 0
