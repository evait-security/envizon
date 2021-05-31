#!/bin/sh

if [ -z ${1} ]; then file=$(date +"%Y-%m-%d_%H-%M"); else file=$1; fi
db_connection_string="--dbname=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@:5432/${POSTGRES_DB}?host=${POSTGRES_HOST}"
echo "[*] Backup database ..."
pg_dump -c -b -F tar -f /tmp/envizon.db.tar ${db_connection_string} || exit
echo "[*] Backup images ..."
tar -cf /tmp/envizon.storage.tar storage/
echo "[*] Packing archive ..."

tar -zcf /backup/envizon_$file.tar.gz -C /tmp envizon.storage.tar envizon.db.tar
rm /tmp/envizon.storage.tar /tmp/envizon.db.tar
echo "[+] Done. File is located in ./envizon_backup/envizon_$file.tar.gz"
