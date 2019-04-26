#!/bin/bash -e

# runs scripts on local machine under jenkins slave

if [ -z "$JENKINS_URL" ]; then
  echo "Error: trying to run not on jenkins slave. Aborting."
  exit 1
fi

# install pyenv
if [ ! -d "$HOME/.pyenv" ]; then
  curl https://pyenv.run | bash
fi

# pyenv init
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# install python version from .python-version
pyenv --version
pyenv install -s

python --version

# create virtualenv and activate it
pyenv virtualenv --force --python=python3 workstation
pyenv activate workstation

# install dependencies via pip
pip install --upgrade pip==19.1
pip install -r requirements.txt

# some verbose commands
ansible --version

# code quality
ansible-lint desktop.yml
yamllint -f parsable .

# ansible syntax check
ansible-playbook -vvv --syntax-check desktop.yml

# ansible run locally
ansible-playbook -vvv desktop.yml --connection=local
