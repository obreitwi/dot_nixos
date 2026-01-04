# home manager config for xmonad
{
  lib,
  config,
  pkgs,
  pkgs-stable,
  dot-desktop,
  ...
}: let
  inherit (config.my.stalonetray) slot-size num-icons;

  trayWidth = slot-size * num-icons;

  myplayerctl = pkgs.writeShellApplication {
    name = "myplayerctl";
    runtimeInputs = with pkgs; [
      gnugrep
      playerctl
    ];
    text = builtins.readFile "${dot-desktop}/scripts/myplayerctl";
  };
in {
  options.my.gui.xmonad.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  options.my.stalonetray = {
    num-icons = lib.mkOption {
      default = 6;
      type = lib.types.int;
    };

    slot-size = lib.mkOption {
      # default = 18;
      default = 16;
      type = lib.types.int;
    };
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.xmonad.enable) {
    xsession.windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };

    home.file.".xmonad/lib" = {
      source = "${dot-desktop}/xmonad/lib";
      recursive = true;
    };

    home.file.".xmonad/xmonad.hs" = {
      source = "${dot-desktop}/xmonad/xmonad.hs";
    };

    home.packages = [
      myplayerctl
      pkgs.autorandr
      pkgs.rofimoji
      pkgs.toggle-bluetooth-audio
      pkgs-stable.trayer # xmonad
      pkgs.xclip
      pkgs.xss-lock
    ];

    services.stalonetray = {
      enable = false;
      config = {
        # back background
        background = "#000000";
        # 8 size icons with padding
        icon_size = "${toString (slot-size - 2)}";
        slot_size = "${toString slot-size}";
        # up to ten icons in top right corner
        geometry = "${toString num-icons}x1-0+0";
        # icons are on the right
        icon_gravity = "E";
        skip_taskbar = true;
        # force icon sizes
        kludges = "force_icons_size";
        # xmonad handles that
        window_strut = "none";
      };
    };

    home.file.".xmonad/run-trayer.sh" = {
      text = ''
        #!/usr/bin/env bash
        trayer \
        --monitor primary \
        --edge top \
        --align right \
        --width ${toString trayWidth} \
        --widthtype pixel \
        --height ${toString (slot-size + 1)} \
        --padding 0 \
        --tint 0x000000 \
        --transparent true \
        --alpha 0 \
        --expand false \
        --SetDockType true 2>&1 \
        | systemd-cat -t trayer
      '';
      executable = true;
    };
  };
}
