#!/bin/bash -ex

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
pyenv install

python --version

# create virtualenv and activate it
pyenv virtualenv --python=python3 workstation
pyenv activate workstation

