#!/bin/sh
if [ -z "$SSL_KEY_PATH" ]
then
  if [[ -f .ssl/localhost.key && -f .ssl/localhost.crt ]]
  then
    echo "Certificates found in .ssl/."
  else
    echo "No certificates provided and none in .ssl/, generating some for you"
    openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 \
      -subj "/C=DE/ST=None/L=None/O=evait/CN=None" \
      -keyout .ssl/localhost.key  -out .ssl/localhost.crt
  fi
else
  echo "Using certificates provided by environment variables."
fi

if [ -z "$SECRET_KEY_BASE" ]
then
  echo "No rails secret provided via '\$SECRET_KEY_BASE'."
  echo "You need to set it in the docker-compose.yml or as an environment variable!"
  exit
fi

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
bundle exec rails assets:precompile
exec bundle exec rails server
