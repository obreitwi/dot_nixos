{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: {
  options.my.gui.redshift.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.redshift.enable) {
    services.redshift = {
      enable = true;
      package = pkgs-stable.redshift;
      provider = "manual";
      latitude = 53.551086;
      longitude = 9.993682;
    };
  };
}
