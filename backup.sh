#!/bin/bash

volumenes=$(sudo docker volume ls -q | grep single-node)
directorio="/tmp/wazuh-backup"
mkdir "$directorio"
sudo chmod 777 "$directorio"

for volumen in $volumenes; do
    echo "Haciendo copia de seguridad del volumen $volumen"
    sudo docker run --rm -v "$volumen":/data -v "$directorio":/backup busybox tar cvf /backup/"$volumen".tar /data &>/dev/null
done

sudo chown user:user "$directorio"/*
mv "$directorio" $(pwd)
