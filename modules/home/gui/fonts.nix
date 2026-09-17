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
      mononoki

      # newer versions have partial emoji support which looks ugly, waiting for an option to remove them alltogher
      pkgs.stable.nerd-fonts.iosevka
      pkgs.stable.nerd-fonts.iosevka-term
    ];
    fonts.fontconfig.enable = true;
  };
}
