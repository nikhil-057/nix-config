#!/usr/bin/env bash
set -euo pipefail
CWD="$(pwd)"
trap "cd $CWD" EXIT
cd "$(dirname "$0")"
unset NIX_BUILD_SHELL
mkdir -p ~/.config
rm -rf ~/.config/home-manager
ln -rsfv . ~/.config/home-manager
rm -f ~/.gitconfig
nix-shell
