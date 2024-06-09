# common configurations in home manager for both nixos and standalone
{hostname, ...}: {
  my.latex.enable = builtins.elem hostname ["mimir" "mucku"];
  my.revcli.enable = builtins.elem hostname ["mimir"];
  my.terraform.enable = builtins.elem hostname ["mimir"];
}
