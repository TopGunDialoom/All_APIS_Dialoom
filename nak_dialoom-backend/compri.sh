#!/usr/bin/env bash
################################################################################
# compri.sh
# Script para generar un único archivo "dialoom_backend_snapshot.sh" que
# reconstruya todos los ficheros y carpetas de tu backend, incluyendo .env,
# claves, etc., sin excluir nada.
#
# Para evitar el error "sed: RE error: illegal byte sequence" en macOS, forzamos
# el locale a UTF-8. Además, usamos iconv para ignorar bytes inválidos.
################################################################################

# 1) Fuerza el locale en macOS para evitar "illegal byte sequence"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Nombre del archivo final donde se guardará el snapshot
SNAPSHOT_FILE="dialoom_backend_snapshot.sh"

# Limpia el snapshot anterior (si existía)
rm -f "$SNAPSHOT_FILE"

# Cabecera del script resultante
cat << 'EOF' > "$SNAPSHOT_FILE"
#!/usr/bin/env bash
# ==========================================================================
# dialoom_backend_snapshot.sh
# Este script recreará la estructura de carpetas y archivos de tu backend
# tal como estaba cuando lo generaste con "compri.sh".
# ==========================================================================
EOF

# Añadimos una línea en blanco tras la cabecera
echo "" >> "$SNAPSHOT_FILE"

# 2) Recorre todas las carpetas (type d) y genera los comandos para recrearlas
#    Excluye el "." inicial para no crear la carpeta raíz duplicada
echo "echo 'Creando estructura de directorios...'" >> "$SNAPSHOT_FILE"
find . -type d | while read -r dir; do
  # Quita el "./" del principio
  cleanDir="${dir#./}"

  # Si cleanDir está vacío, es la raíz: no hace falta crearla
  if [ "$cleanDir" != "" ]; then
    # Escapamos espacios
    escapedDir=$(printf %q "$cleanDir")
    echo "mkdir -p \"$escapedDir\"" >> "$SNAPSHOT_FILE"
  fi
done
echo "" >> "$SNAPSHOT_FILE"

# 3) Recorre todos los archivos (type f) y genera los comandos para recrearlos
#    Excluye el propio script para que no se autocontenga
echo "echo 'Creando ficheros...'" >> "$SNAPSHOT_FILE"
find . -type f | while read -r file; do
  # No incluir:
  # - El script que genera el snapshot (compri.sh)
  # - El script resultante (dialoom_backend_snapshot.sh)
  # Si quieres excluir más archivos, añádelos aquí:
  if [[ "$file" == "./compri.sh" || "$file" == "./dialoom_backend_snapshot.sh" ]]; then
    continue
  fi

  # Quitamos el "./" inicial
  cleanFile="${file#./}"
  # Escapa espacios
  escapedFile=$(printf %q "$cleanFile")

  # Usamos iconv con //IGNORE para forzar UTF-8 y evitar secuencias ilegales
  # Luego escapamos backticks con sed
  CONTENT=$(iconv -f UTF-8 -t UTF-8//IGNORE "$file" \
           | sed 's/\r$//g' \
           | sed 's/`/\\`/g')

  # Generamos un bloque 'cat << "EOF" > filename ... EOF' con el contenido
  echo "cat << '__EOC__' > \"$escapedFile\"" >> "$SNAPSHOT_FILE"
  echo "$CONTENT" >> "$SNAPSHOT_FILE"
  echo "__EOC__" >> "$SNAPSHOT_FILE"
  echo "" >> "$SNAPSHOT_FILE"
done

# 4) Opcional: Ajustar permisos si deseas (por ejemplo, .sh a +x)
#   Ejemplo (descomenta si quieres que todos los .sh sean ejecutables):
# echo "echo 'Ajustando permisos en scripts...'" >> "$SNAPSHOT_FILE"
# find . -type f -name "*.sh" | while read -r shfile; do
#   if [[ "$shfile" != "./$0" && "$shfile" != "./$SNAPSHOT_FILE" ]]; then
#     cleanedShFile="${shfile#./}"
#     echo "chmod +x \"$cleanedShFile\"" >> "$SNAPSHOT_FILE"
#   fi
# done

# 5) Mensaje final
echo "echo 'Snapshot recreado con éxito.'" >> "$SNAPSHOT_FILE"

# 6) Otorgamos permisos de ejecución al snapshot
chmod +x "$SNAPSHOT_FILE"

echo "Se ha generado el script '$SNAPSHOT_FILE'. Ejecútalo en la máquina destino con:"
echo "  ./$SNAPSHOT_FILE"
echo "para recrear toda la estructura."

exit 0
