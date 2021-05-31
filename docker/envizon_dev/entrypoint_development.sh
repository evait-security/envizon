#!/bin/sh

if [[ ! -f report-templates/envizon_template.docx ]]; then
  mkdir -p report-templates
  cp report-templates/envizon_template.docx.example report-templates/envizon_template.docx
fi

if [[ -f db/envizon.db.tar ]]
then
  echo "Restoring existing database dump."
  db_connection_string="--dbname=postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@:5432/${POSTGRES_DB}?host=${POSTGRES_HOST}"
  pg_restore -c ${db_connection_string} db/envizon.db.tar || exit
  rm -f db/envizon.db.tar
fi

rm -f /usr/src/app/envizon/tmp/pids/server.pid
bundle exec rails db:migrate
bundle exec rails db:seed
exec bundle exec rails server
