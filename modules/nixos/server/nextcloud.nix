{
  lib,
  config,
  pkgs,
  myUtils,
  ...
}: let
  inherit (config.my.server) nextcloud;

  domain = myUtils.getDomain lib nextcloud.hostName;
in {
  options = {
    my.server.nextcloud = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };

      hostName = lib.mkOption {
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf nextcloud.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud29;
      inherit (nextcloud) hostName;

      # Instead of using pkgs.nextcloud28Packages.apps,
      # we'll reference the package version specified above
      extraApps = {
        keeweb = pkgs.fetchNextcloudApp {
          sha256 = "11q15ajg1357y5y5a640dvsy6hhvvar7wp34zfsb07n7hqlmyci0";
          url = "https://github.com/jhass/nextcloud-keeweb/releases/download/v0.6.13/keeweb-0.6.13.tar.gz";
          license = "agpl3Plus";
        };
      };
      extraAppsEnable = true;

      config.adminpassFile = "/var/lib/secrets/nextcloud_admin.pw";
      https = true;
      maxUploadSize = "10G";
    };

    services.nginx.enable = true;

    services.nginx.virtualHosts."${nextcloud.hostName}" = myUtils.nginxACME domain;
  };
}
