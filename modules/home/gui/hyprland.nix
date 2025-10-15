# NOTE: Still very much work-in-progress!
{
  config,
  pkgs,
  lib,
  nixGL,
  ...
}: {
  options.my.gui.hyprland.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.hyprland.enable) {
    nixGL = {
      packages = nixGL.packages; # you must set this or everything will be a noop
      defaultWrapper = "mesa"; # choose from nixGL options depending on GPU
    };

    services.hyprpolkitagent.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;
      package =
        if (config.my.isNixOS)
        then pkgs.hyprland
        else config.lib.nixGL.wrap pkgs.hyprland;

      xwayland.enable = true;

      settings = {
        debug.disable_logs = true; # TODO: Disable once done.

        bind = [
          "Super Shift, Return, exec, alacritty"
          "Super, M, exec, rofi -show run -sort"

          "Super Shift, F4, exit"
        ];

        general = {
          gaps_in = 3;
          gaps_out = 3;
          border_size = 1;

          follow_mouse = 2; # focus follows on click
        };

        # TODO hypridle
        # TODO hyprsunset

        input = {
          kb_model = "pc105";
          kb_layout = "us";
          kb_variant = "altgr-intl";
          kb_options = [
            "compose:menu"
            "compose:prsc"
            "lv3:ralt_switch"
            "eurosign:e"
            "nbsp:level3n"
            "caps:escape"
          ];
        };
        exec-once = [
          "waybar"
          "iwgtk -i"

          "blueman-applet"
          "gnome-keyring-daemon --start --components=secrets"
        ];
      };

      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };

    services.hyprpaper = {
      enable = true;

      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = ["${config.home.homeDirectory}/wallpaper/current"];

        wallpaper = [
          ",${config.home.homeDirectory}/wallpaper/current"
        ];
      };
    };

    programs.waybar = {
      enable = true;
    };

    #home.pointerCursor.hyprcursor.enable = true;

    home.packages = [
      pkgs.blueman
      pkgs.nwg-displays
      pkgs.wl-clipboard
    ];
  };
}
