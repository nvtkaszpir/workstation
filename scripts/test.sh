#!/bin/bash -x

# runs scripts on local machine under jenkins slave

if [ -z "$JENKINS_URL" ]; then
  echo "Error: trying to run not on jenkins slave. Aborting."
  exit 1
fi

# install pyenv
curl https://pyenv.run | bash

# pyenv init
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install -f "$WORKSPACE/.python-version"

python --version
