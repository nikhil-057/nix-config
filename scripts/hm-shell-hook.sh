#!/usr/bin/env bash
set -euo pipefail
CWD="$(pwd)"
trap "cd $CWD" EXIT
cd "$(dirname "$0")/.."
unset NIX_BUILD_SHELL
mkdir -p ~/.config
rm -rf ~/.config/home-manager
ln -rsfv home-manager ~/.config/home-manager
nix-shell "<home-manager>" -A install
## need the following because podman does not play nicely with newuidmap
## more reading: https://github.com/nix-community/home-manager/pull/4801#issuecomment-2308715379
if [ -n "$(command -v podman)" ] && [ -z "$(command -v newuidmap)" ] && [ -f "/etc/debian_version" ]
then
    sudo apt install uidmap --yes
fi
