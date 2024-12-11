{
  system ? builtins.currentSystem,
}:
let
configDir =
  builtins.substring
    0
    (builtins.sub (builtins.stringLength __curPos.file) 10)
    __curPos.file;
sources = import (configDir + "/npins");
pkgs = import sources.nixpkgs {
  inherit system;
  config = {};
  overlays = [];
};
in
with pkgs; stdenv.mkDerivation {
 name = "nix-user-config";
  inherit configDir;
  nixPath =
    ":nixpkgs=" + sources.nixpkgs +
    ":home-manager=" + sources.home-manager;
  buildInputs = [
    nix
  ];
  shellHook =
    "export NIX_PATH=\$nixPath;" +
    "\$configDir/scripts/hm-setup.sh;" +
    "exit";
}
