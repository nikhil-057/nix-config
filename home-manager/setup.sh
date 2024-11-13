#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p ~/.config
rm -rf ~/.config/home-manager
ln -rsfv . ~/.config/home-manager
home-manager switch

## https://github.com/nix-community/home-manager/pull/4801#issuecomment-2308715379
if [ -n "$(command -v podman)" ] && [ -z "$(command -v newuidmap)" ]
then
    sudo apt install uidmap --yes
fi
