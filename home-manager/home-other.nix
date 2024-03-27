# home manager config only used on desktops not running nixOS
{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-input,
  dot-desktop,
  backlight,
  hostname,
  ...
}: let
in {
  imports = [
    ./home.nix
    ../modules/alacritty.nix
    ../modules/xmonad.nix
  ];

  isNixOS = false;

  home.packages = with pkgs-unstable; [
    backlight
  ];

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
}
