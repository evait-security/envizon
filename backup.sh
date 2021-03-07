#!/bin/sh
pg_dump -h /var/run/postgresql -U envizon envizon > /tmp/dump_envizon
pg_dump -h /var/run/postgresql -U envizon envizon_development > /tmp/dump_envizon_development
pg_dump -h /var/run/postgresql -U envizon envizon_test > /tmp/dump_envizon_test

tar -zcf /tmp/storage.tar.gz storage/
tar -cf backup.tar -C /tmp/ storage.tar.gz dump_envizon dump_envizon_development dump_envizon_test

rm -f /tmp/dump_envizon
rm -f /tmp/dump_envizon_development
rm -f /tmp/dump_envizon_test
rm -f /tmp/storage.tar.gz
