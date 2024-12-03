#!/usr/bin/env bash
set -euo pipefail
CWD="$(pwd)"
trap "cd $CWD" EXIT
cd "$(dirname "$0")/.."
unset NIX_BUILD_SHELL
mkdir -p ~/.config
rm -rf ~/.config/home-manager
nix-shell "<home-manager>" -A install
rm -rf ~/.config/home-manager
ln -rsfv home-manager ~/.config/home-manager
rm -f ~/.gitconfig
~/.nix-profile/bin/home-manager switch -b backup
