#!/bin/bash

# runs scripts on local machine

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

pyenv install -f .python-version

python --version
