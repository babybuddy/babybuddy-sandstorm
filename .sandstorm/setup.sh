#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# Install system dependencies.
apt-get update
apt-get install
apt-get install -y nginx uwsgi uwsgi-plugin-python3 python3-venv sqlite3 git

# Install pipx and pipenv.
python3 -m pip install --user pipx
python3 -m pipx ensurepath
source ~/.profile
pipx install pipenv

# Disable nginx (controlled by `launcher.sh`).
service nginx stop
systemctl disable nginx
