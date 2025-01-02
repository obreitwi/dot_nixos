# NOTE keep in sync with ../nixos/gnupg.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gnupg.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.gnupg.enable {
    home.packages = with pkgs; [
      gnupg
    ];

    services.gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-rofi;

      defaultCacheTtl = 86400;
      defaultCacheTtlSsh = 86400;
      maxCacheTtl = 86400;
      maxCacheTtlSsh = 86400;

      enableSshSupport = true;
      enableExtraSocket = true;
    };
  };
}
