#!/usr/bin/env bash
set -euo pipefail
CWD="$(pwd)"
trap "cd $CWD" EXIT
cd "$(dirname "$0")/.."
NIX_BUILD_SHELL=bash nix-shell --pure -A setupHomeManager
