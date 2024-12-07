{
  pkgs ? import <nixpkgs> { },
  hmAttrs ? import <home-manager> { }
}:
let
  home-manager = hmAttrs.home-manager;
in
  hmAttrs.install.override {
    shellHook = ''
      exec ${home-manager}/bin/home-manager init --switch --no-flake -b backup
    '';
  }
