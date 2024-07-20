{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gui.firefox.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.firefox.enable) {
    home.packages = [
      pkgs.firefox
    ];
  };
}
