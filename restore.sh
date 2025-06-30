#!/bin/bash

# Directorio donde se encuentran los archivos .tar que contienen los respaldos de los volúmenes
BACKUP_DIR="/home/wazuh-backup"  # Cambia esta ruta a donde descomprimiste los .tar
# Obtener la lista de archivos .tar
TAR_FILES=$(ls $BACKUP_DIR/*.tar)

# Iterar sobre cada archivo .tar y restaurarlo en su respectivo volumen de Docker
for TAR_FILE in $TAR_FILES; do
    # Obtener el nombre del volumen eliminando el prefijo y la extensión .tar
    VOLUME_NAME=$(basename $TAR_FILE .tar)

    # Crear el volumen en Docker
    echo "Creando volumen de Docker: $VOLUME_NAME"
    sudo docker volume create $VOLUME_NAME

    # Restaurar el contenido del archivo .tar en el volumen
    echo "Restaurando el contenido del archivo $TAR_FILE al volumen $VOLUME_NAME"
    sudo docker run --rm -v $VOLUME_NAME:/data -v $BACKUP_DIR:/backup busybox tar xvf /backup/$VOLUME_NAME.tar -C /data --strip-components=1
done

echo "Restauración completada exitosamente."
