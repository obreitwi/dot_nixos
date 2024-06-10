# home manager config only used on desktops not running nixOS
{...}: {
  imports = [../modules/home ./common.nix];

  isNixOS = false;

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
}
