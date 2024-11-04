#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

ln -rsfv config ~/.config/home-manager

## TODO: move these into home.nix
#mkdir -p ~/.config/nvim
ln -rsfv dotfiles/init.lua ~/.config/nvim/init.lua
ln -rsfv dotfiles/tmux.conf ~/.tmux.conf
ln -rsfv dotfiles/profile ~/.profile
ln -rsfv dotfiles/zshrc ~/.zshrc
