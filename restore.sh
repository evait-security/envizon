#!/bin/sh

if [ -z ${1} ]; then
  echo "[-] Error. No filename was given. Please provide the full name e.g. docker-compose exec envizon /bin/sh restore.sh envizon_customername.tar.gz"
  exit
else
  file=$1
fi

echo "[*] Copy backup to /tmp/"
cp /backup/$1 /tmp/backup.tar.gz
echo "[*] Extracting database & images backup ..."
tar -xf /tmp/backup.tar.gz -C db/
echo "[*] Clean up ..."
rm -f /tmp/backup.tar.gz
echo "-----------------------------------------------------"
echo "[!] Success. Please restart the envizon app container now in order to restore the database and all images."
echo "[*] Use: docker-compose restart envizon"
