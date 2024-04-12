{
  lib,
  config,
  pkgs,
  ...
}: let
  package = pkgs.zellij;
in {
  programs.zellij = {
    enable = true;
    inherit package;
    settings = {
      theme = "gruvbox-dark";
      default_mode = "locked";
    };
  };
}
