#### Bootstrapping home-manager
`"$(nix-build --quiet --no-out-link -A setupHomeManager https://github.com/nikhil-057/nix-config/archive/refs/tags/v8.0.tar.gz)/bin/setup-home-manager"`

#### Using nix-shell
`NIX_PATH="$("$(nix-build --quiet --no-out-link -A echoNixPath https://github.com/nikhil-057/nix-config/archive/refs/tags/v8.0.tar.gz)/bin/echo-nix-path")" nix-shell -p hello --run hello`
