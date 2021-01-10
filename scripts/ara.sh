#!/bin/bash

# when you rsync files from vagrant back to host then they clash with default
# config, so we must override it

source <(python -m ara.setup.env)

ARA_BASE_DIR="$(git rev-parse --show-toplevel)/reports/ara/db"
export ARA_BASE_DIR

ARA_LOG_CONFIG="$(git rev-parse --show-toplevel)/ara_logconfig.yml"
export ARA_LOG_CONFIG

ARA_BASE_DIR="$(git rev-parse --show-toplevel)/reports/ara/db"
export ARA_BASE_DIR

ARA_DATABASE_NAME="$(git rev-parse --show-toplevel)/reports/ara/db/ansible.sqlite"
export ARA_DATABASE_NAME

ARA_TIME_ZONE="Etc/UTC"
export ARA_TIME_ZONE

# spawn ara webserver so that you can see results

ara-manage runserver
