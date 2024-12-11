{
  system ? builtins.currentSystem,
}:
let
  sources = import ./npins;
  nixPath =
    ":nixpkgs=" + sources.nixpkgs +
    ":home-manager=" + sources.home-manager;
  pkgs = import sources.nixpkgs {
    inherit system;
    config = {};
    overlays = [];
  };
  hmDir = pkgs.lib.fileset.toSource {
    root = ./home-manager;
    fileset = ./home-manager/.;
  };
in with pkgs; {
  echoNixPath = stdenv.mkDerivation {
    name = "echo-nix-path";
    shellHook =
      "echo ${nixPath};" +
      "exit";
  };
  setupHomeManager = stdenv.mkDerivation {
    name = "setup-home-manager";
    buildInputs = [
      nix
    ];
    shellHook =
      "export NIX_PATH=${nixPath};" +
      "${hmDir}/setup-hook.sh;" +
      "exit";
  };
}
