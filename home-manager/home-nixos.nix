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
  imports = [./home.nix ../home-modules/xmonad.nix];

  isNixOS = true;

  home.file."${config.home.homeDirectory}/.xinitrc".source = "${dot-desktop}/x11/xinitrc";

  # needed for xmobar
  home.packages = with pkgs-unstable; [backlight ttf-envy-code-r];

  services.keynav.enable = true;
}
