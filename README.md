## Bootstrapping home-manager
`NIX_BUILD_SHELL=bash nix-shell --pure -A hmSetup https://github.com/nikhil-057/nix-config/archive/refs/tags/v1.0.tar.gz`

## Setting NIX_PATH
`export NIX_PATH="$(NIX_BUILD_SHELL=bash nix-shell --pure -A echoNixPath https://github.com/nikhil-057/nix-config/archive/refs/tags/v1.0.tar.gz)"`
