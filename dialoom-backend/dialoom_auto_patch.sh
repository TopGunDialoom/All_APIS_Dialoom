#!/usr/bin/env bash
# ==========================================================================
# dialoom_auto_patch.sh
# Script único que contiene el parche y lo aplica directamente
# usando "git apply". No requiere copiar/pegar nada adicional.
#
# Instrucciones:
#   1) Ubica este archivo en la raíz del repositorio.
#   2) chmod +x dialoom_auto_patch.sh
#   3) ./dialoom_auto_patch.sh
#
# Si todo va bien, el parche quedará aplicado a tu repo local.
# ==========================================================================

echo "[INFO] Aplicando parche autoincluido..."

# Aquí viene *TODO EL CONTENIDO* del parche diff. 
# Ajusta los paths (a/..., b/...), etc. al tuyo real.

git apply --reject --whitespace=fix --unidiff-zero - <<'END_OF_DIFF'
diff --git a/src/app.module.ts b/src/app.module.ts
index 1234567..89abcde 100644
--- a/src/app.module.ts
+++ b/src/app.module.ts
@@ -1,0 +2,14 @@
+import { Module } from '@nestjs/common';
+import { ConfigModule } from '@nestjs/config';
+import { TypeOrmModule } from '@nestjs/typeorm';
+import { AuthModule } from './auth/auth.module';
+
+@Module({
+  imports: [
+    ConfigModule.forRoot({ isGlobal: true }),
+    TypeOrmModule.forRootAsync({
+      useFactory: () => ({ /* ... */ }),
+    }),
+    AuthModule
+  ],
+})
+export class AppModule {}
diff --git a/src/auth/auth.service.ts b/src/auth/auth.service.ts
index f3bde45..648ade0 100644
--- a/src/auth/auth.service.ts
+++ b/src/auth/auth.service.ts
@@ -10,6 +10,12 @@ export class AuthService {
     // ...
 }
END_OF_DIFF

STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo "[OK] Parche aplicado con éxito."
else
  echo "[ERROR] Ocurrió un problema al aplicar el parche (status=$STATUS)."
  echo "       Revisa si hay archivos .rej o conflictos."
  exit 1
fi

echo "[DONE] Fin del script."
