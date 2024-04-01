# home manager config only used on desktops not running nixOS
{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-input,
  dot-desktop,
  hostname,
  ...
}: let
in {
  imports = [../home-modules];

  isNixOS = false;

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
}
