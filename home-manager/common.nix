# common configurations in home manager for both nixos and standalone
{hostname, ...}: let
  isDesktop = builtins.elem hostname ["mimir" "mucku"];
  isWork = builtins.elem hostname ["mimir"];
in {
  my.azure.enable = isWork;

  my.go.enable = isWork;

  my.gui = {
    enable = isDesktop;

    keepass.enable = builtins.elem hostname ["mucku"];
    nextcloud.enable = builtins.elem hostname ["mucku"];
    redshift.enable = builtins.elem hostname ["mimir" "mucku"];
    redshift.enable = isDesktop;
    slock.enable = false;
    x11base.enable = builtins.elem hostname ["mimir"];
    xmobar.enable = isDesktop;
    xmonad.enable = isDesktop;
  };

  my.latex.enable = isDesktop;
  my.revcli.enable = isWork;
  my.terraform.enable = isWork;

  my.work.enable = isWork;
}
