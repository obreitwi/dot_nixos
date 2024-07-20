{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gui.iwd.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.iwd.enable) {
    home.packages = [
      pkgs.iwgtk
    ];
    fonts.fontconfig.enable = true;
  };
}
