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
  echoNixPath = writeShellScriptBin "echo-nix-path" ''
    echo "${nixPath}"
  '';
  setupHomeManager = writeShellScriptBin "setup-home-manager" ''
    export PATH="${lib.makeBinPath [ bash coreutils nix ]}"
    export NIX_PATH="${nixPath}"
    ${hmDir}/setup-hook.sh
  '';
}
