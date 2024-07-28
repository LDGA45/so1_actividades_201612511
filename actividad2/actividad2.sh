#!/bin/bash

# Definir la variable GITHUB_USER
GITHUB_USER="LDGA45"

# Verificar si GITHUB_USER está definido
if [ -z "$GITHUB_USER" ]; then
    echo "La variable GITHUB_USER no está definida. Por favor, defínela y vuelve a intentarlo."
    exit 1
fi

# Consultar la URL y obtener datos en formato JSON
API_URL="https://api.github.com/users/${GITHUB_USER}"
USER_DATA=$(curl -s $API_URL)

# Verificar si el usuario existe
USER_ID=$(echo $USER_DATA | jq -r '.id')
if [ "$USER_ID" == "null" ]; then
    echo "El usuario ${GITHUB_USER} no existe en GitHub."
    exit 1
fi

# Extraer la información necesaria usando jq
CREATED_AT=$(echo $USER_DATA | jq -r '.created_at')

# Imprimir el mensaje
MESSAGE="Hola ${GITHUB_USER}. User ID: ${USER_ID}. Cuenta fue creada el: ${CREATED_AT}."
echo $MESSAGE

# Crear el log file
DATE=$(date '+%Y-%m-%d')
LOG_DIR="/tmp/${DATE}"
mkdir -p $LOG_DIR
echo $MESSAGE >> "${LOG_DIR}/saludos.log"

# Agregar una entrada de cron para ejecutar el script cada 5 minutos
CRON_JOB="*/5 * * * * /path/to/this_script.sh"
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
