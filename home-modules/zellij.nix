{
  lib,
  config,
  pkgs-unstable,
  ...
}:
let   package = pkgs-unstable.zellij;
in
{
  programs.zellij = {
    enable = true;
    inherit package;
    settings = {
      theme = "gruvbox-dark";
      default_mode = "locked";
    };
  };
}
