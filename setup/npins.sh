#!/usr/bin/env bash
set -euo pipefail
CWD="$(pwd)"
trap "cd $CWD" EXIT
cd "$(dirname "$0")/.."
export NIX_PATH="$("$(nix-build --quiet --no-out-link -A echoNixPath)/bin/echo-nix-path")"
nix-shell -p npins --run " \
  npins init --bare; \
  npins add github nixos nixpkgs --branch nixos-unstable; \
  npins add github nikhil-057 home-manager --branch customizable-shellhook; \
  npins add github nix-community nixvim --branch main; \
"
