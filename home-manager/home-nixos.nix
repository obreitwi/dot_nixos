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
  imports = [../modules/home];

  isNixOS = true;

  services.keynav.enable = true;
}
