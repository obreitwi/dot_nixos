{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gui-apps.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.xmonad.enable {
    home.packages = with pkgs; [
      bluetuith
      discord
      neovide
      gnupg
    ];

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 86400;
      defaultCacheTtlSsh = 86400;
      maxCacheTtl = 86400;
      maxCacheTtlSsh = 86400;

      enableSshSupport = true;

      pinentryPackage = pkgs.pinentry-gtk2;
    };
  };
}
