#!/bin/sh

if [ -z ${1} ]; then
  echo "[-] Error. No filename was given. Please provide the full name e.g. docker-compose exec envizon /bin/sh restore.sh envizon_customername.tar.gz"
  exit
else
  file=$1
fi

db_connection_string="--dbname=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@:5432/${POSTGRES_DB}?host=${POSTGRES_HOST}"

echo "[*] Copy backup to /tmp/"
cp /backup/$1 /tmp/backup.tar.gz
echo "[*] Extracting ..."
tar -xf /tmp/backup.tar.gz -C /tmp/
echo "[*] Clean up ..."
rm -f /tmp/backup.tar.gz
rm -rf storage/
echo "[*] Restore images ..."
tar -xf /tmp/envizon.storage.tar
echo "[*] Copy database backup ..."
cp /tmp/envizon.db.tar db/envizon.db.tar
echo "[*] Clean up ..."
rm /tmp/envizon.db.tar
rm /tmp/envizon.storage.tar
echo "-----------------------------------------------------"
echo "[!] Success. Please restart the envizon app container now in order to restore the database."
echo "[*] Use: docker-compose restart envizon"
