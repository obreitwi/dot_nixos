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
  patch = ../../patches/slock/slock-pam_no_priv_drop.patch;
  slock =
    if config.my.slock.patch
    then
      pkgs.slock.overrideAttrs (
        final: prev: {
          buildInputs = prev.buildInputs ++ [pkgs.linux-pam];
          patches = prev.patches or [] ++ [patch];
        }
      )
    else pkgs.slock;
in {
  options.my.slock.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  options.my.slock.patch = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.slock.enable {
    environment.systemPackages = [slock];
    security.wrappers.slock = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${slock.out}/bin/slock";
    };
    security.pam.services.slock = {};
  };
}
