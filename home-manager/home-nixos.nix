# home manager config only used on desktops
{
  lib,
  config,
  pkgs,
  pkgs-input,
  backlight,
  dot-desktop,
  hostname,
  ...
}: {
  imports = [../home-modules];

  isNixOS = true;

  services.keynav.enable = true;
}
