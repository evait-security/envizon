#!/bin/sh

if [[ ! -f report_templates/envizon_template.docx ]]; then
  mkdir -p report_templates
  cp report_templates/envizon_template.docx.example report_templates/envizon_template.docx
fi

rm -f /usr/src/app/envizon/tmp/pids/server.pid
bundle exec rails db:migrate
bundle exec rails db:seed
exec bundle exec rails server
