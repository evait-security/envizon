#!/bin/sh
rm -f /usr/src/app/envizon/tmp/pids/server.pid
bundle exec rails db:migrate
bundle exec rails db:seed
exec bundle exec rails server
