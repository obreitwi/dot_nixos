# home manager config only used on desktops
{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-input,
  dot-desktop,
  hostname,
  ...
}: {
  imports = [../modules/xmonad.hs];

  isNixOS = true;

  home.file."${config.home.homeDirectory}/.xinitrc".source = "${dot-desktop}/x11/xinitrc";

  # needed for xmobar
  home.packages = with pkgs-unstable; [ttf-envy-code-r];

  services.keynav.enable = true;
}
