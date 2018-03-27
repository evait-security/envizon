#!/bin/sh
rm -f /usr/src/app/envizon/tmp/pids/server.pid
rails db:migrate
rails db:seed
exec rails server
