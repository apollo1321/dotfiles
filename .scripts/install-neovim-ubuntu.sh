#!/usr/bin/env bash

source ~/.scripts/colors.sh

info "Adding neovim repo\n"
add-apt-repository ppa:neovim-ppa/stable
apt update
info "Installing neovim\n"
apt install neovim
info "Installed neovim:\n $(eval nvim --version)"

info "Installing tools for telescope plugin\n"
info "Installing ripgrep\n"
apt install ripgrep
info "Installing fd-find\n"
apt install fd-find

