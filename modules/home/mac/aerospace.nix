{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: {
  options.my.aerospace.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.isMacOS && config.my.aerospace.enable) {
    programs.aerospace = {
      enable = true;

      launchd.enable = true;
    };
  };
}
