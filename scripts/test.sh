#!/bin/bash -e
PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_VIRTUALENV_DISABLE_PROMPT
# fix issues with time reports, especially in ara
export TZ=Etc/UTC

if [ -d "/vagrant" ]; then
  echo "Running in vagrant, faking some things..."
  JENKINS_URL="http://127.0.0.1/"
  export JENKINS_URL
  export WORKDIR="/vagrant"
fi

# runs scripts on local machine under jenkins slave

if [ -z "$JENKINS_URL" ]; then
  echo "Error: trying to run not on jenkins slave. Aborting."
  exit 1
fi

# install pyenv
if [ ! -d "$HOME/.pyenv" ]; then
  curl -s https://pyenv.run | bash
fi

# pyenv init
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

cd "${WORKDIR}"
# install python version from .python-version
pyenv --version
pyenv install -s

python --version

# create virtualenv and activate it
pyenv virtualenv --force --python=python3 workstation
pyenv activate workstation

# install dependencies via pip
pip install --upgrade pip==20.3.3
pip install -r requirements.txt

# code quality

echo "======== Stage: linters - ansible-lint ========"
ansible-lint desktop.yml
echo "======== Stage: linters - yamllint ========"
yamllint -f parsable .

echo "======== Stage: ansible-galaxy ========"
# some verbose commands
ansible-galaxy --version
ansible-galaxy install -r requirements.yml

echo "======== Stage: ansible ara config ======"
# prepare ansible ara for local reports
export ANSIBLE_CALLBACK_PLUGINS="$(python3 -m ara.setup.callback_plugins)"
ARA_BASE_DIR="$(pwd)/reports/ara/db"
export ARA_BASE_DIR

echo "======== Stage: ansible ========"
# some verbose commands
ansible --version
# ansible syntax check
ansible-playbook --syntax-check desktop.yml

# ansible run locally
set +e
ansible-playbook desktop.yml --connection=local
result=$?
set -e

echo "======== Stage: ansible ara report ======"
# prepare ansible ara for local reports

# generate reports
ara-manage generate "$(pwd)/reports/ara/html/"
ara-manage generate "$(pwd)/reports/ara/junit/"

exit $result
