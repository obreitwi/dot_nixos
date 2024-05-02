# home manager config only used on desktops not running nixOS
{
  hostname,
  ...
}: {
  imports = [../home-modules];

  isNixOS = false;

  my.latex.enable = hostname == "mimir";
  my.revcli.enable = hostname == "mimir";

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
}
