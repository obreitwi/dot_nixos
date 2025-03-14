{
  lib,
  config,
  ...
}: {
  options = {
    my.server.acme.staging = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = {
    security.acme = {
      acceptTerms = true;
      defaults = lib.mkIf config.my.server.acme.staging {
        server = "https://acme-staging-v02.api.letsencrypt.org/directory";
      };
    };
  };
}
