#!/usr/bin/env bash
set -euo pipefail
CWD="$(pwd)"
trap "cd $CWD" EXIT
cd "$(dirname "$0")/.."
export NIX_PATH="$(NIX_BUILD_SHELL=bash nix-shell --pure -A echoNixPath)"
nix-shell -p npins --run " \
  npins init --bare; \
  npins add github nixos nixpkgs --branch nixos-unstable; \
  npins add github nikhil-057 home-manager --branch customizable-shellhook; \
"
