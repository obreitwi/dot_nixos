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

      config.adminpassFile = "/var/lib/secrets/nextcloud_admin.pw";
      https = true;
      maxUploadSize = "10G";
    };

    services.nginx.enable = true;

    services.nginx.virtualHosts."${nextcloud.hostName}" = {
      forceSSL = true;
      sslCertificate = "/var/lib/acme/${domain}/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/${domain}/key.pem";
      sslTrustedCertificate = "/var/lib/acme/${domain}/chain.pem";
    };
  };
}
