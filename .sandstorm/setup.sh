#!/bin/bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install
apt-get install -y nginx uwsgi uwsgi-plugin-python3 python-virtualenv pipenv sqlite3 git
service nginx stop
systemctl disable nginx
