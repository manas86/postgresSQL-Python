#!/usr/bin/env bash

# turn on bash's job control
set -m

# Start the primary process and put it in the background
/app/idle.sh &
# Start initialization of postgres
/app/startPostgreSQL.sh
# test python
python3 /app/test-postgres.py

# now we bring the primary process back into the foreground
# and leave it there
fg %1

