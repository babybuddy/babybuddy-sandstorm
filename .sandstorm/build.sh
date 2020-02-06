#!/bin/bash
set -euo pipefail

cd /opt/app

# Get application code.
VERSION=$(cat /opt/app/VERSION)
if [ ! -d /opt/app/babybuddy ] ; then
  git clone https://github.com/babybuddy/babybuddy.git
else
  cd /opt/app/babybuddy
  git fetch origin
fi
cd /opt/app/babybuddy
git checkout v"${VERSION}"

# Set up virtual environment.
VENV=/opt/app/babybuddy/.venv
if [ ! -d $VENV ] ; then
  cd /opt/app/babybuddy
  export PIPENV_VENV_IN_PROJECT=1
  pipenv --three --bare install
else
    echo "$VENV exists, moving on"
fi
