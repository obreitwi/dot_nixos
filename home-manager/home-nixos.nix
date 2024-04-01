# home manager config only used on desktops
{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-input,
  backlight,
  dot-desktop,
  hostname,
  ...
}: {
  imports = [../home-modules];

  isNixOS = true;

  home.file."${config.home.homeDirectory}/.xinitrc".source = "${dot-desktop}/x11/xinitrc";

  services.keynav.enable = true;
}
