# common configurations in home manager for both nixos and standalone
{
  hostname,
  pkgs,
  lib,
  ...
}: let
  isDesktop = builtins.elem hostname [
    "mimir"
    "minir"
    "mucku"
  ];

  hasXmonad = builtins.elem hostname ["mucku"];
  isWork = builtins.elem hostname ["mimir" "minir"];
in {
  imports = [
    ../../modules/home
  ];

  my.isMacOS = pkgs.stdenv.hostPlatform.isDarwin;

  programs.home-manager.enable = true;
  programs.nix-index.enable = true;
  programs.nix-index.enableZshIntegration = false;

  my.chrome.utils = isWork;

  my.azure.enable = isWork && false; # currently not needed (& broken)

  my.go.enable = isWork;

  my.gnupg.enable = isDesktop;

  my.gui = {
    enable = isDesktop;
    stylix.enable = lib.mkDefault isDesktop;

    keepass.enable = builtins.elem hostname ["mucku" "gentian"];

    nextcloud.enable = builtins.elem hostname ["mucku"];
    redshift.enable = isDesktop;
    slock.enable = false;
    x11base.enable = builtins.elem hostname [
      "mimir"
      "minir"
      "mucku"
    ];
    xmobar.enable = hasXmonad;
    xmonad.enable = hasXmonad;
  };

  my.latex.enable = builtins.elem hostname ["mucku"];
  my.libreoffice.enable = builtins.elem hostname ["mucku"];
  my.revcli.enable = isWork;
  my.revcli.sync-job = isWork;
  my.terraform.enable = isWork;
  my.wrepson.enable = isDesktop;

  my.work.enable = isWork;
}
