{
  lib,
  config,
  pkgs,
  ...
}: let
  package = pkgs.zellij;
in {
  programs.zellij = {
    enable = false; # intereferes with zsh startup, investigate prior to enabling
    inherit package;
    settings = {
      theme = "gruvbox-dark";
      default_mode = "locked";
    };
  };
}
