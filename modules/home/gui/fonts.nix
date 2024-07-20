{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gui.fonts.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.fonts.enable) {
    home.packages = [
      (pkgs.nerdfonts.override {
        fonts = ["DejaVuSansMono" "Iosevka" "IosevkaTerm" "Mononoki"];
      })
    ];
    fonts.fontconfig.enable = true;
  };
}
