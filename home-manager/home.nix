# generic home-manager file

{ lib, config, pkgs, inputPkgs, ... }:
let
  tmuxPlugins = import ../modules/tmux-plugins.nix pkgs;
  shellPackages = import ../modules/shell-packages.nix {inherit pkgs; inherit inputPkgs;};
in
{
  home.packages = shellPackages ++ tmuxPlugins;

  home.username = "obreitwi";
  home.homeDirectory = "/home/obreitwi";

  programs.zsh.enable = false; # will overwrite zshrc

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "23.11";
}
