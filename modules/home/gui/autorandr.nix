{
  config,
  lib,
  pkgs,
  ...
}: let
  # TODO sync with x11base
  startPicom =
    pkgs.writeShellScript "start-picom.sh"
    /*
    bash
    */
    ''
      # setup picom
      if command -v picom &>/dev/null; then
          picom_args=(-b)
          # If we use nvidia as the main renderer -> compose with glx backend
          if [[ "$(hostname)" == "mimir" ]] && [ "$(glxinfo | grep "OpenGL renderer")" = "OpenGL renderer string: NVIDIA RTX A1000 Laptop GPU/PCIe/SSE2" ]; then
              picom_args+=(--backend glx --xrender-sync-fence)
          fi
          picom "''${picom_args[@]}"
      fi
    '';

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
          ${startPicom}
          if [ -e ~/wallpaper/current ] && which feh>/dev/null; then
            feh --bg-fill ~/wallpaper/current
          fi
        '';
    };
  };
}
