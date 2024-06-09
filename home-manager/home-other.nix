# home manager config only used on desktops not running nixOS
{hostname, ...}: {
  imports = [../modules/home];

  isNixOS = false;

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
}
