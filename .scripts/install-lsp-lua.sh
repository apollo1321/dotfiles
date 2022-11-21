#!/usr/bin/env bash

set -e

source $(eval pwd)/colors.sh

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  error "unimplemented for linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  brew install lua-language-server
fi
