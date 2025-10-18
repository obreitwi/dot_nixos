# NOTE: Still very much work-in-progress!
{
  config,
  pkgs,
  lib,
  nixGL,
  ...
}: let
  start-Hyprland = pkgs.writeShellApplication {
    name = "start-Hyprland";
    text = ''
      unset LD_LIBRARY_PATH
      exec Hyprland
    '';
  };
  notification-count = pkgs.writeShellApplication {
    name = "notification-count";
    text = ''
      dunstctl count | grep History | awk '$2 > 0 { print "󰨄 " $2 }'
    '';
  };
in {
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

    services.flameshot.enable = true;
    services.flameshot.settings.General.useGrimAdapter = true;

    wayland.windowManager.hyprland = {
      enable = true;
      package =
        if (config.my.isNixOS)
        then pkgs.hyprland
        else config.lib.nixGL.wrap pkgs.hyprland;

      xwayland.enable = true;

      settings = {
        debug.disable_logs = true;

        binds = {
          allow_workspace_cycles = true;
          drag_threshold = 10; # Fire a drag event only after dragging for more than 10px
        };

        bindm = [
          "Super, mouse:272, movewindow" # Super + LMB: Move a window by dragging more than 10px.
          "Super, mouse:273, resizewindow" # Super + RMB: Move a window by dragging more than 10px.
        ];
        bindc = [
          "Super, mouse:272, togglefloating" # Super + LMB: Floats a window by clicking
        ];

        bind = [
          "Super Shift, Return, exec, alacritty"
          "Super, M, exec, rofi -show run -sort"
          "Super, I, exec, rofi -show window"

          "Super Shift, F4, exit"

          "Super Shift, C, killactive,"
          "Super, Y, togglefloating,"

          "Super, P, fullscreen, 1"
          "Super Shift, P, fullscreen, 0"

          "Super, Q, layoutmsg, movetoroot"
          "Super, Q, layoutmsg, movetoroot active unstable"

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

          "Shift Super, 1, movetoworkspace, 1"
          "Shift Super, 2, movetoworkspace, 2"
          "Shift Super, 3, movetoworkspace, 3"
          "Shift Super, 4, movetoworkspace, 4"
          "Shift Super, 5, movetoworkspace, 5"
          "Shift Super, 6, movetoworkspace, 6"
          "Shift Super, 7, movetoworkspace, 7"
          "Shift Super, 8, movetoworkspace, 8"
          "Shift Super, 9, movetoworkspace, 9"
          "Shift Super, 0, movetoworkspace, 10"

          "Shift Super Ctrl, H, movetoworkspace, r-1" # Go to workspace on the left
          "Shift Super Ctrl, L, movetoworkspace, r+1" # Go to workspace on the right

          # Navigate between workspaces with modifier + Alt + arrow keys
          "Super Ctrl, H, workspace, e-1" # Go to workspace on the left
          "Super Ctrl, L, workspace, e+1" # Go to workspace on the right

          # Move between monitors
          "Super, S, movecurrentworkspacetomonitor, l"
          "Super, D, movecurrentworkspacetomonitor, r"

          "Super Alt, L, exec, hyprlock"

          "Super Ctrl, P, exec, flameshot gui"

          "Super Ctrl, SPACE, exec, dunstctl history-pop"
          "Super, B, exec, dunstctl close-all"
          "Super Shift, B, exec, dunstctl history-clear"
        ];

        workspace = [
          "w[t1], border:false" # don't draw borders if there is only one window
          "f[1],  border:false, gapsin:0, gapsout:0, rounding:false" # don't draw borders if we maximise one window
        ];

        general = {
          gaps_in = 2;
          gaps_out = 2;
          border_size = 1;
          layout = "dwindle";
          resize_on_border = true;
        };

        monitor = ", preferred, auto, 1";

        decoration = {
          rounding = 5;
        };

        #follow_mouse = 2; # focus follows on click

        dwindle = {
          pseudotile = true;
          #preserve_split = true;
        };

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
          #"iwgtk -i"

          #"blueman-applet"
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

    home.file."${config.xdg.configHome}/waybar/config" = {
      source = ../../../config-files/waybar/config.jsonc;
    };
    home.file."${config.xdg.configHome}/waybar/scripts/uptime.sh" = {
      executable = true;
      text =
        /*
        bash
        */
        ''
          #!/bin/bash

          #UPTIME_FORMATTED=$(awk '$1 / 3600 / 24 > 0 { printf("%dd ", ($1/(3600 * 24))) } { printf("%dh", (($1 % (3600*24)) / 3600))}' </proc/uptime)
          #UPTIME_FORMATTED=$(echo "$UPTIME_PRETTY"| sed 's/^up //;s/,*$//;s/minute/m/; s/hour/h/; s/day/d/; s/s//g')
          #UPTIME_FORMATTED=$(uptime | awk '{ print $3 }' | tr -d ',' | sed -e 's/:[0-9]\{2\}\s.*$//')
          UPTIME_FORMATTED=$(uptime | awk '{ print $3 }' | tr -d ',')

          echo " $UPTIME_FORMATTED"
        '';
    };
    programs.waybar = {
      enable = true;
      style = ../../../config-files/waybar/style.css;
      # settings.mainBar = { /* set in config file */ };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 300;
            on-timeout = "hyprlock";
          }
          {
            timeout = 600;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };

        animations = {
          enabled = true;
          fade_in = {
            duration = 300;
            bezier = "easeOutQuint";
          };
          fade_out = {
            duration = 300;
            bezier = "easeOutQuint";
          };
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        auth = {
          "fingerprint:enabled" = true;
        };

        input-field = [
          {
            size = "150, 40";
            position = "0, -380";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
            shadow_passes = 2;
          }
        ];
      };
    };

    services.hyprsunset.enable = true;

    #home.pointerCursor.hyprcursor.enable = true;

    home.packages = [
      pkgs.blueman
      pkgs.nwg-displays
      pkgs.wev
      pkgs.wl-clipboard
      pkgs.wlprop

      start-Hyprland
      notification-count
    ];
  };
}
