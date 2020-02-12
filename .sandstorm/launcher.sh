#!/bin/bash
set -euo pipefail

# Remove /var/run and /var/tmp because.
rm -rf /var/run
mkdir -p /var/run
rm -rf /var/tmp
mkdir -p /var/tmp

# Set up database.
mkdir -p /var/sqlite3
cd /opt/app/babybuddy

# Establish environment.
mkdir -p /var/env
if [ ! -f /var/env/secret ]; then
  python3 -c 'import random; result = "".join([random.choice("abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)") for i in range(50)]); print(result);' > /var/env/secret
fi
export DJANGO_SETTINGS_MODULE="babybuddy.settings.sandstorm"
export SECRET_KEY="$(cat /var/env/secret)"

# Set up database.
pipenv run python manage.py migrate
pipenv run python manage.py createcachetable

# Add media folder for uploads
mkdir -p /var/media

# Set up uwsgi.
UWSGI_SOCKET_FILE=/var/run/uwsgi.sock
HOME=/var uwsgi \
  --socket $UWSGI_SOCKET_FILE \
  --plugin python3 \
  --chdir /opt/app/babybuddy \
  --virtualenv /opt/app/babybuddy/.venv \
  --module babybuddy.wsgi:application \
  --wsgi-file /opt/app/babybuddy/babybuddy/wsgi.py &
while [ ! -e $UWSGI_SOCKET_FILE ] ; do
    echo "waiting for uwsgi to be available at $UWSGI_SOCKET_FILE"
    sleep .2
done

# Set up nginx
mkdir -p /var/lib/nginx
mkdir -p /var/log/nginx
/usr/sbin/nginx -c /opt/app/.sandstorm/service-config/nginx.conf -g "daemon off;"
