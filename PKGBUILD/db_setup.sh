#!/bin/bash
cd /var/lib/postgres
psql -v ON_ERROR_STOP=1  <<-EOSQL
    CREATE DATABASE envizon;
    CREATE USER envizon WITH PASSWORD 'envizon';
    GRANT ALL PRIVILEGES ON DATABASE envizon TO envizon;
    ALTER USER envizon WITH SUPERUSER;
EOSQL
