#!/bin/bash
set -euo pipefail

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

# Checkout desired version and apply Sandstorm patch.
VERSION=$(grep -oE 'appMarketingVersion = \(defaultText = "(.+)"' /opt/app/.sandstorm/sandstorm-pkgdef.capnp | cut -d '"' -f2)
cd /opt/app/babybuddy
git add --all
git checkout -f v"${VERSION}"
git apply /opt/app/sandstorm.patch

# Set up virtual environment.
VENV=/opt/app/babybuddy/.venv
if [ ! -d $VENV ] ; then
  cd /opt/app/babybuddy
  export PIPENV_VENV_IN_PROJECT=1
  pipenv --three --bare install
else
    echo "$VENV exists, moving on"
fi
