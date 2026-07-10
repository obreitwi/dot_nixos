{
  pkgs,
  config,
  lib,
  ...
}: {
  options.my.nextcloud-client.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.iwd.enable {
    environment.systemPackages = with pkgs; [
      nextcloud-client
    ];

    # for nextcloud
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.lightdm.enableGnomeKeyring = true;
  };
}
