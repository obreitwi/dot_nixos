# home manager config only used on desktops not running nixOS
{...}: {
  imports = [../modules/home ../modules/home/xsession ./common.nix];

  isNixOS = false;

  programs.home-manager.enable = true;
}
