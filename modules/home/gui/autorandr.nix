{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gui.autorandr.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.autorandr.enable) {
    home.packages = with pkgs; [
      autorandr
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
          picom -b
          if [ -e ~/wallpaper/current ] && which feh>/dev/null; then
            feh --bg-fill ~/wallpaper/current
          fi
        '';
    };
  };
}
