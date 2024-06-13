{
  config,
  lib,
  ...
}: {
  options.my.gui.redshift.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.redshift.enable) {
    services.redshift = {
      enable = true;
      provider = "geoclue2";
    };
  };
}
