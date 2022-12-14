#!/usr/bin/env bash

set -e

source $(eval pwd)/colors.sh

info "Adding neovim repo\n"
apt-get install -y software-properties-common
add-apt-repository -y ppa:neovim-ppa/stable
apt update
info "Installing neovim\n"
apt install -y neovim
info "Installed neovim:\n $(eval nvim --version)\n"

info "Installing tools for telescope plugin\n"
apt install -y ripgrep fd-find
