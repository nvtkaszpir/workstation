#!/bin/bash

# install pyenv
curl https://pyenv.run | bash

# pyenv init
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install

python --version
