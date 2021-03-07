#!/bin/sh
rm -rf storage/
tar -xf backup.tar -C /tmp/
tar -xzf /tmp/storage.tar.gz

psql -h /var/run/postgresql -U envizon envizon < /tmp/dump_envizon
psql -h /var/run/postgresql -U envizon envizon_development < /tmp/dump_envizon_development
psql -h /var/run/postgresql -U envizon envizon_test < /tmp/dump_envizon_test

rm -f /tmp/dump_envizon
rm -f /tmp/dump_envizon_development
rm -f /tmp/dump_envizon_test
rm -f /tmp/storage.tar.gz

# rm -f backup.tar
