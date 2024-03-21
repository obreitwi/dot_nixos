{ lib, config, pkgs, inputPkgs, isNixOS, ... }:
let
  tmuxPlugins = import ../modules/tmux-plugins.nix pkgs;
  shellPackages = import ../modules/shell-packages.nix {
    inherit pkgs;
    inherit inputPkgs;
  };
in {
  home.packages = shellPackages ++ tmuxPlugins;

  home.username = "obreitwi";
  home.homeDirectory = "/home/obreitwi";

  targets.genericLinux.enable = !isNixOS;

  programs.zsh.enable = false; # will overwrite zshrc

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";

  home.sessionVariables = {
    # EDITOR = "nvim";
  };
}
