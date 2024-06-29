{
  lib,
  config,
  ...
}: let
in {
  options = {
    my.server.acme.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
    my.server.acme.staging = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.my.server.acme.enable {
    security.acme = {
      acceptTerms = true;
      defaults =
        lib.mkIf config.my.server.acme.staging
        {
          server = "https://acme-staging-v02.api.letsencrypt.org/directory";
        };

      certs = builtins.listToAttrs (map (domain: {
          name = domain;
          value = {
            domain = "*.${domain}";
            email = "admin+acme@${domain}";
            dnsProvider = "hetzner";
            environmentFile = "/var/lib/secrets/hetzner_dns.conf";
          };
        }) [
          "zqnr.de"
          "initialcommit.org"
          "breitwieser.eu"
        ]);
    };
  };
}
