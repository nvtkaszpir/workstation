#!/bin/bash

# spawn ara webserver so that you can see results
source <(python -m ara.setup.env)
ARA_DIR="$(git rev-parse --show-toplevel)/reports/ara/db"
export ARA_DIR
ARA_LOG_CONFIG="$(git rev-parse --show-toplevel)/ara_logconfig.yml"
export ARA_LOG_CONFIG
ara-manage runserver
