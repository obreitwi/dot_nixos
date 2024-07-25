{
  lib,
  config,
  pkgs,
  ...
}: let
  # patch = pkgs.fetchurl {
  # url = "https://tools.suckless.org/slock/patches/pam_auth/slock-pam_auth-20190207-35633d4.diff";
  # hash = "sha256-TMuX/JGce7Y8OAEWx/u3gyd95DiLcqHZ4CkyupOLkDY=";
  # };
  patch = ../../../patches/slock/slock-pam_no_priv_drop.patch;
  pkg-slock =
    if config.my.gui.slock.patch
    then
      pkgs.slock.overrideAttrs (
        final: prev: {
          buildInputs = prev.buildInputs ++ [pkgs.linux-pam];
          patches = prev.patches or [] ++ [patch];
        }
      )
    else pkgs.slock;
in {
  options.my.gui.slock = {
    enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };

    patch = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = let
    inherit (config.my) gui;
  in
    lib.mkIf (gui.enable && gui.slock.enable) {
      home.packages = [pkg-slock];
      # home-manager does not yet support setuid wrapper
      # security.wrappers.slock = {
      # setuid = true;
      # owner = "root";
      # group = "root";
      # source = "${pkg-slock.out}/bin/slock";
      # };
      # security.pam.services.slock = {};
    };
}
