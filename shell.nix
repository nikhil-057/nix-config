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
  nixPath =
    ":nixpkgs=" + sources.nixpkgs +
    ":home-manager=" + sources.home-manager;
  pkgs = import sources.nixpkgs {
    inherit system;
    config = {};
    overlays = [];
  };
in with pkgs; {
  echoNixPath = stdenv.mkDerivation {
    name = "echo-nix-path";
    shellHook =
      "echo ${nixPath};" +
      "exit";
  };
  hmSetup = stdenv.mkDerivation {
    name = "hm-setup";
    buildInputs = [
      nix
    ];
    shellHook =
      "export NIX_PATH=${nixPath};" +
      "${configDir}/scripts/hm-setup.sh;" +
      "exit";
  };
}
