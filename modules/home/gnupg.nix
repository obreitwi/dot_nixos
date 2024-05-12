{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gnupg.enable = lib.mkOption {
    default = config.my.gui-apps.enable;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.gnupg.enable {
    home.packages = [
      pkgs.gnupg
    ];

    services.gpg-agent = {
      enable = true;

      defaultCacheTtl = 86400;
      defaultCacheTtlSsh = 86400;
      maxCacheTtl = 86400;
      maxCacheTtlSsh = 86400;

      enableSshSupport = true;
      enableExtraSocket = true;

      pinentryPackage = pkgs.pinentry-rofi;
    };

    # NOTE not using nixos module prorams.gnupg.agent until needed!
  };
}
