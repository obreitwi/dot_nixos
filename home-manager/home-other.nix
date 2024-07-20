# home manager config only used on desktops not running nixOS
{...}: {
  imports = [../modules/home ./common.nix];

  isNixOS = false;

  programs.home-manager.enable = true;

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
}
