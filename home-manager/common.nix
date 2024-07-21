# common configurations in home manager for both nixos and standalone
{hostname, ...}: {
  my.azure.enable = builtins.elem hostname ["mimir"];

  my.gui.keepass.enable = !builtins.elem hostname ["mimir"];
  my.gui.nextcloud.enable = !builtins.elem hostname ["mimir"];

  my.go.enable = builtins.elem hostname ["mimir"];

  my.gui = {
    enable = !builtins.elem hostname ["gentian"];
    redshift.enable = builtins.elem hostname ["mimir" "mucku"];
  };

  my.latex.enable = builtins.elem hostname ["mimir" "mucku"];
  my.revcli.enable = builtins.elem hostname ["mimir"];
  my.terraform.enable = builtins.elem hostname ["mimir"];

  my.work.enable = builtins.elem hostname ["mimir"];
}
