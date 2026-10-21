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
      package = pkgs.nextcloud34;
      inherit (nextcloud) hostName;

      # Instead of using pkgs.nextcloud28Packages.apps,
      # we'll reference the package version specified above
      extraApps = {
        #keeweb = pkgs.fetchNextcloudApp {
        #sha256 = "sha256-+G9N67SluucmsYRJ3P8KosBqQn9D7xnA/0m8ZUvHO0c=";
        #url = "https://github.com/jhass/nextcloud-keeweb/releases/download/v0.6.20/keeweb-0.6.20.tar.gz";
        #license = "agpl3Plus";
        #};
      };
      extraAppsEnable = false;

      # - The option definition `services.nextcloud.config.adminpassFile' in `/nix/store/33injb090x4iq8d33ic608fg0xblm580-source/modules/nixos/server/nextcloud.nix' no longer has any effect; please remove it.
      # To create an admin user after the installation, use nextcloud-occ user:add <username> and nextcloud-occ group:adduser admin <username>.
      #config.adminpassFile = "/var/lib/secrets/nextcloud_admin.pw";
      config.dbtype = "sqlite";
      https = true;
      maxUploadSize = "10G";
    };

    services.nginx.enable = true;

    services.nginx.virtualHosts."${nextcloud.hostName}" = myUtils.nginxACME domain;
  };
}
