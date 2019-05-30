#!/bin/bash

# spawn ara webserver so that you can see results
source <(python -m ara.setup.env)
export ARA_DIR="$(git rev-parse --show-toplevel)/reports/ara/db"
export ARA_LOG_CONFIG="$(git rev-parse --show-toplevel)/ara_logconfig.yml"
ara-manage runserver
