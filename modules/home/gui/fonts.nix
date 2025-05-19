{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gui.fonts.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.fonts.enable || config.my.gui.enable) {
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
