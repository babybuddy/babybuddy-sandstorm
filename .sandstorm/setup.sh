#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# Install system dependencies.
apt-get update
apt-get install
apt-get install -y nginx uwsgi uwsgi-plugin-python3 python3-pip python3-venv sqlite3 git

# Install pipx and pipenv.
python3 -m pip install --user pipx
python3 -m pipx ensurepath
source ~/.profile
if ! [ -x "$(command -v git)" ]; then
    pipx install --ignore-installed pipenv
fi

# Disable nginx (controlled by `launcher.sh`).
service nginx stop
systemctl disable nginx
