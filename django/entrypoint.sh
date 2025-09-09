#!/usr/bin/env sh
pip install psycopg2-binary
set -e
until python - <<'PY'
import os, psycopg2, time
from psycopg2 import OperationalError
host=os.getenv("DATABASE_HOST","db")
db=os.getenv("POSTGRES_NAME")
user=os.getenv("POSTGRES_USER")
pwd=os.getenv("POSTGRES_PASSWORD")
for _ in range(60):
    try:
        psycopg2.connect(host=host, dbname=db, user=user, password=pwd).close()
        break
    except OperationalError:
        time.sleep(2)
else:
    raise SystemExit("DB not ready")
PY
do :; done

python manage.py migrate
exec "$@"