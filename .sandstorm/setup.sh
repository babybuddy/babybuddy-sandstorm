#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# Install system dependencies.
apt-get update
apt-get install
apt-get install -y nginx uwsgi uwsgi-plugin-python3 python-virtualenv pipenv sqlite3 git

# Disable nginx (controlled by `launcher.sh`).
service nginx stop
systemctl disable nginx

# Get application code.
cd /opt/app
rm -rf babybuddy
git clone https://github.com/babybuddy/babybuddy.git

# Set up required application environment variables.
SECRET_KEY=$(python -c 'import random; result = "".join([random.choice("abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)") for i in range(50)]); print(result)')
cat <<EOF > /opt/app/babybuddy/.env
DJANGO_SETTINGS_MODULE=babybuddy.settings.sandstorm
SECRET_KEY=$SECRET_KEY
EOF
