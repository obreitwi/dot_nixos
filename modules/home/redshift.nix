{
  config,
  lib,
  ...
}: {
  options.my.gui-apps.redshift.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui-apps.enable && config.my.gui-apps.redshift.enable) {
    services.redshift = {
      enable = true;
      provider = "geoclue2";
    };
  };
}
