#!/usr/bin/env bash
set -euo pipefail
CWD="$(pwd)"
trap "cd $CWD" EXIT
cd "$(dirname "$0")/.."
exec "$(nix-build --quiet --no-out-link -A setupHomeManager)/bin/setup-home-manager"
