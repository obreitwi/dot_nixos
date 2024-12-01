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
    # keep in sync with nixos fonts
    home.packages = with pkgs.nerd-fonts; [
      dejavu-sans-mono
      iosevka
      iosevka-term
      mononoki
    ];
    fonts.fontconfig.enable = true;
  };
}
