# home manager config only used on desktops
{ lib, config, pkgs, pkgs-unstable, pkgs-input, isNixOS, dot-desktop, hostname
, ... }: {
  home.file."${config.home.homeDirectory}/.xinitrc".source =
    "${dot-desktop}/x11/xinitrc";

  # xmonad config
  home.file."${config.home.homeDirectory}/.xmonad/lib" = {
    source = "${dot-desktop}/xmonad/lib";
    recursive = true;
  };
  home.file."${config.home.homeDirectory}/.xmonad/xmonad.hs" = {
    source = "${dot-desktop}/xmonad/xmonad.hs";
  };
  home.file."${config.home.homeDirectory}/.xmonad/xmobar" = {
    source = "${dot-desktop}/xmonad/xmobar.${hostname}";
  };
  services.keynav.enable = true;
}
