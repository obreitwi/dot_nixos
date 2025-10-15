# NOTE: Still very much work-in-progress!
{
  config,
  pkgs,
  lib,
  nixGL,
  ...
}: {
  options.my.gui.hyprland.enable = lib.mkOption {
    default = false;
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

        binds = {
          allow_workspace_cycles = true;
          drag_threshold = 10; # Fire a drag event only after dragging for more than 10px
        };

        bindm = [
          "Super, mouse:272, movewindow" # Super + LMB: Move a window by dragging more than 10px.
        ];
        bindc = [
          "Super, mouse:272, togglefloating" # Super + LMB: Floats a window by clicking
        ];

        bind = [
          "Super Shift, Return, exec, alacritty"
          "Super, M, exec, rofi -show run -sort"

          "Super Shift, F4, exit"

          "Super Shift, C, killactive,"
          "Super Shift, Space, togglefloating,"

          "Super, P, fullscreen"

          # Move focus with modifier + arrow keys
          "Super, H, movefocus, l"
          "Super, L, movefocus, r"
          "Super, K, movefocus, u"
          "Super, J, movefocus, d"

          # Move window with modifier + Shift + arrow keys
          "Super Shift, H, movewindow, l"
          "Super Shift, L, movewindow, r"
          "Super Shift, K, movewindow, u"
          "Super Shift, J, movewindow, d"

          # Switch workspaces with modifier + [0-9]
          "Super, 1, workspace, 1"
          "Super, 2, workspace, 2"
          "Super, 3, workspace, 3"
          "Super, 4, workspace, 4"
          "Super, 5, workspace, 5"
          "Super, 6, workspace, 6"
          "Super, 7, workspace, 7"
          "Super, 8, workspace, 8"
          "Super, 9, workspace, 9"
          "Super, 0, workspace, 10"

          # Navigate between workspaces with modifier + Alt + arrow keys
          "Super Ctrl, H, workspace, e-1" # Go to workspace on the left
          "Super Ctrl, L, workspace, e+1" # Go to workspace on the right

          # Move between monitors
          "Super, S, movecurrentworkspacetomonitor, l"
          "Super, D, movecurrentworkspacetomonitor, r"
        ];

        general = {
          gaps_in = 5;
          gaps_out = 5;
          radius = 5;
          border_size = 1;
        };

        decorations = {
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
