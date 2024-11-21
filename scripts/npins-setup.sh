#!/usr/bin/env bash
set -euo pipefail
CWD="$(pwd)"
trap "cd $CWD" EXIT
cd "$(dirname "$0")/.."
nix-shell -p npins --run " \
  npins init --bare; \
  npins add github nix-community home-manager --branch master; \
  npins add github nixos nixpkgs --branch nixos-unstable; \
"
