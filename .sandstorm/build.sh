#!/bin/bash
set -euo pipefail

# Save or create an .env file.
if [ -f /opt/app/babybuddy/.env ]; then
  mv /opt/app/babybuddy/.env /opt/app
else
  SECRET_KEY=$(python -c 'import random; result = "".join([random.choice("abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)") for i in range(50)]); print(result)')
  cat <<EOF > /opt/app/.env
DJANGO_SETTINGS_MODULE=babybuddy.settings.sandstorm
SECRET_KEY=$SECRET_KEY
EOF
fi

# Get application code.
cd /opt/app
rm -rf babybuddy
git clone https://github.com/babybuddy/babybuddy.git

# Checkout desired version and apply Sandstorm patch.
VERSION=$(grep -oE 'appMarketingVersion = \(defaultText = "(.+)"' /opt/app/.sandstorm/sandstorm-pkgdef.capnp | cut -d '"' -f2)
cd /opt/app/babybuddy
git add --all
git checkout -f v"${VERSION}"
git apply /opt/app/sandstorm.patch

# Move .env file in to application directory.
mv /opt/app/.env /opt/app/babybuddy/.env

# Set up virtual environment.
VENV=/opt/app/babybuddy/.venv
if [ ! -d $VENV ] ; then
  cd /opt/app/babybuddy
  export PIPENV_VENV_IN_PROJECT=1
  pipenv --three --bare install
else
    echo "$VENV exists, moving on"
fi
