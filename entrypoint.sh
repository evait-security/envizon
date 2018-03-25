#!/bin/sh
rm -f /usr/src/app/envizon/tmp/pids/server.pid
rails db:migrate
rails db:seed
rails assets:precompile
exec rails server
