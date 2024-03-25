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
  imports = [
    ../modules/alacritty.nix
    ../modules/xmonad.nix
  ];

  isNixOS = false;

  home.packages = with pkgs-unstable; [
    xorg.xbacklight
  ];

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
}
