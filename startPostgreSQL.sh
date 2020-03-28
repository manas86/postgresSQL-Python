#!/usr/bin/env bash

initdb -D /var/lib/postgresql/data
pg_ctl -D /var/lib/postgresql/data -l /var/log/postgresql/log.log start
psql --command "ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres';"
psql --command "CREATE DATABASE dvdrental;"
pg_restore -U postgres -d dvdrental /app/dvdrental.tar
#/usr/lib/postgresql/12/bin/postgres -D /var/lib/postgresql/data -c /var/lib/postgresql/data/postgresql.conf

