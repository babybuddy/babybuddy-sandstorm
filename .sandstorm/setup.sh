#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

# Install system dependencies.
apt-get update
apt-get install
apt-get install -y nginx uwsgi uwsgi-plugin-python3 python3-pip python3-venv pipenv sqlite3 git

# Disable nginx (controlled by `launcher.sh`).
service nginx stop
systemctl disable nginx
