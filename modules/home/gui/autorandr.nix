{
  config,
  lib,
  pkgs,
  ...
}: let
  rofi-autorandr = pkgs.writeShellApplication {
    name = "rofi-autorandr";
    runtimeInputs = [pkgs.autorandr pkgs.gawk pkgs.rofi];
    text = ''
      layout=$(autorandr | rofi -dmenu -p "Layout" -sort | awk '{ print $1}')

      autorandr --load "$layout"
    '';
  };
in {
  options.my.gui.autorandr.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.autorandr.enable) {
    home.packages = with pkgs; [
      autorandr
      rofi-autorandr
    ];

    home.file."${config.xdg.configHome}/autorandr/preswitch" = {
      executable = true;
      text =
        /*
        bash
        */
        ''
          #!/usr/bin/env bash

          set -euo pipefail
          killall picom
        '';
    };
    home.file."${config.xdg.configHome}/autorandr/postswitch" = {
      executable = true;
      text =
        /*
        bash
        */
        ''
          #!/usr/bin/env bash

          set -euo pipefail
          xmonad --restart

          if command -v start-picom &>/dev/null; then
            start-picom
          fi
          if [ -e ~/wallpaper/current ] && which feh>/dev/null; then
            feh --bg-fill ~/wallpaper/current
          fi
        '';
    };
  };
}
