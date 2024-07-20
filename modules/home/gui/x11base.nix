{
  config,
  lib,
  pkgs,
  dot-desktop,
  ...
}: {
  options.my.gui.x11base.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.x11base.enable) {
    home.file."${config.xdg.configHome}/.Xmodmap".source = "${dot-desktop}/x11/Xmodmap";
    # home.file."${config.xdg.configHome}/.Xdefaults".source = "${dot-desktop}/x11/Xdefaults";

    home.packages = with pkgs; [
      backlight
      picom
      rofi
      xdg-utils
      xterm

      # backup terminal if nixGL is out of date with GPU drivers
      st
    ];
  };
}
