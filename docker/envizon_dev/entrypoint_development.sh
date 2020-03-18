#!/bin/sh

if [[ ! -f report-templates/envizon_template.docx ]]; then
  mkdir -p report-templates
  cp report-templates/envizon_template.docx.example report-templates/envizon_template.docx
fi

if [[ -f db/envizon.db.tar ]]
then
  file_date=$(date +"%Y-%m-%d-%H:%M")
  echo "Importing existing database dump."
  echo "A backup of the current database will be placed in db/envizon.db.${file_date}.tar"
  db_connection_string="--dbname=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@:5432/${POSTGRES_DB}?host=${POSTGRES_HOST}"
  pg_dump -c -b  -F tar -f db/envizon.db.${file_date}.tar ${db_connection_string} || exit
  pg_restore -c ${db_connection_string} db/envizon.db.tar || exit
  rm -f db/envizon.db.tar
fi

rm -f /usr/src/app/envizon/tmp/pids/server.pid
bundle exec rails db:migrate
bundle exec rails db:seed
exec bundle exec rails server
