# home manager config only used on desktops not running nixOS
{
  lib,
  config,
  pkgs,
  pkgs-input,
  dot-desktop,
  hostname,
  ...
}: {
  imports = [../home-modules];

  isNixOS = false;

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
}
