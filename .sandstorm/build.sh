#!/bin/bash
set -euo pipefail

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
