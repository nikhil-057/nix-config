#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p ~/.config
rm -rf ~/.config/home-manager
ln -rsfv . ~/.config/home-manager
home-manager switch
