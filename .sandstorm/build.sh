#!/bin/bash
set -euo pipefail

# Checkout desired version.
VERSION=$(grep -oE 'appMarketingVersion = \(defaultText = "(.+)"' /opt/app/.sandstorm/sandstorm-pkgdef.capnp | cut -d '"' -f2)
cd /opt/app/babybuddy
git checkout v"${VERSION}"

# Copy in Sandstorm specific application overrides.
cp -rf /opt/app/overrides/* /opt/app/babybuddy

# Set up virtual environment.
VENV=/opt/app/babybuddy/.venv
if [ ! -d $VENV ] ; then
  cd /opt/app/babybuddy
  export PIPENV_VENV_IN_PROJECT=1
  pipenv --three --bare install
else
    echo "$VENV exists, moving on"
fi
