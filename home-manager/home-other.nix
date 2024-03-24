# home manager config only used on desktops not running nixOS
{ lib
, config
, pkgs
, pkgs-unstable
, pkgs-input
, isNixOS
, dot-desktop
, hostname
, ...
}:
let

in {
  # TODO: import xmonad
  imports = [ ../modules/xmonad.nix ];

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

}
