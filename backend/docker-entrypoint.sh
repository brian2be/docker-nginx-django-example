#!/bin/sh
set -e

. /venv/bin/activate
while ! python manage.py migrate
do
    echo "Retry applying migrations..."
    sleep 1
done

exec gunicorn --bind 0.0.0.0:5000 --forwarded-allow-ips='*' backend.wsgi:application