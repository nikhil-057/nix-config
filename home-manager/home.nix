{ config, pkgs, ... }: {

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "nikhil";
  home.homeDirectory = "/home/nikhil";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  #
  # It is sometimes useful to fine-tune packages, for example, by applying
  # overrides. You can do that directly here, just don't forget the
  # parentheses. Maybe you want to install Nerd Fonts with a limited number of fonts?
  #   (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  #
  # You can also create simple shell scripts directly inside your
  # configuration. For example, this adds a command 'my-hello' to your environment:
  #   (pkgs.writeShellScriptBin "my-hello" ''
  #     echo "Hello, ${config.home.username}!"
  #   '')
  home.packages = [
    pkgs.hello
    pkgs.git
    pkgs.neovim
    pkgs.tmux
    pkgs.zsh
    pkgs.oh-my-zsh
    pkgs.gcc
    pkgs.python3
    pkgs.uv
    pkgs.xclip
    pkgs.xorg.xauth
    pkgs.ripgrep
    pkgs.fd
    pkgs.podman
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # Building this configuration will create a copy of 'dotfiles/<filename>' in
  # the Nix store. Activating the configuration will then make '~/<filename>' a
  # symlink to the Nix store copy.
  #
  # You can also set the file content immediately.
  #   ".gradle/gradle.properties".text = ''
  #     org.gradle.console=verbose
  #     org.gradle.daemon.idletimeout=3600000
  #   '';
  home.file = {
    ".config/nvim/init.lua".source = dotfiles/init.lua;
    ".tmux.conf".source = dotfiles/tmux.conf;
    ".profile".source = dotfiles/profile;
    ".zshrc".source = dotfiles/zshrc;
    # https://man.archlinux.org/man/containers-policy.json.5.en
    ".config/containers/policy.json".source = dotfiles/containers-policy.json;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nikhil/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}