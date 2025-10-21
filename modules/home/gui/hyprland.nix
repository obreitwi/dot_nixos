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

  chrome-wrapper = pkgs.writeShellApplication {
    name = "google-chrome";
    text =
      /*
      bash
      */
      ''
        if [[ "''${XDG_BACKEND:-}" == wayland ]] && [ -f /usr/bin/google-chrome-stable ]; then
          unset __EGL_VENDOR_LIBRARY_FILENAMES
          unset LD_LIBRARY_PATH
          unset GBM_BACKENDS_PATH

          # Alternatively: unset all egl related env variables and have chrome discover system libraries by default
          #mapfile -t vars_to_unset < <(env | grep -i mesa | cut -d= -f1)
          #unset "''${vars_to_unset[@]}"
        fi
        /usr/bin/google-chrome-stable "$@"
      '';
  };

  notification-count = pkgs.writeShellApplication {
    name = "notification-count";
    text = ''
      dunstctl count | grep History | awk '$2 > 0 { print "󰨄 " $2 }'
    '';
  };

  scratchpad-journal = pkgs.writeShellApplication {
    name = "scratchpad-journal";
    text = ''
      cd ~/wiki/neorg
      exec alacritty -e nvim '+Neorg journal today'
    '';
  };

  workspace-action = pkgs.writeShellApplication {
    name = "workspace-action";
    text = ''
      action="''$1"
      shift 1

      default_targets=$( \
        grep -o 'workspace=[0-9]\+,defaultName:[^"]\+' ~/.config/hypr/hyprland.conf \
          | sed -e 's/defaultName://' -e 's/workspace=//' \
          | tr ',' "\t" \
      )
      custom_targets=$(hyprctl workspaces -j | jq -r '.[] | select(.name | startswith("special:") | not) | [.id, .name] | @tsv')

      jump_target=$( \
        ( echo "''${default_targets}"; echo "''${custom_targets}" ) \
          | sort -n | uniq \
          | rofi -dmenu -match-only -display-columns 2 -display-column-separator "\t" -p "Workspace" \
          | awk -F "\t" '{ print $1 }'
      )
      hyprctl dispatch "''${action}" "''${jump_target}"
    '';
  };

  workspace-rename = pkgs.writeShellApplication {
    name = "workspace-rename";
    text = ''
      active_workspace=$(hyprctl activeworkspace -j)
      name=$(jq -r .name <<< "''${active_workspace}" | rofi -dmenu -p "New name")
      hyprctl dispatch renameworkspace "$(jq -r .id <<<"''${active_workspace}")" "''${name}"
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
        debug.disable_logs = false;

        binds = {
          allow_workspace_cycles = true;
          movefocus_cycles_fullscreen = true;
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
          "Super Shift, Q, layoutmsg, movetoroot active unstable"

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

          "Shift Super, 1, movetoworkspacesilent, 1"
          "Shift Super, 2, movetoworkspacesilent, 2"
          "Shift Super, 3, movetoworkspacesilent, 3"
          "Shift Super, 4, movetoworkspacesilent, 4"
          "Shift Super, 5, movetoworkspacesilent, 5"
          "Shift Super, 6, movetoworkspacesilent, 6"
          "Shift Super, 7, movetoworkspacesilent, 7"
          "Shift Super, 8, movetoworkspacesilent, 8"
          "Shift Super, 9, movetoworkspacesilent, 9"
          "Shift Super, 0, movetoworkspacesilent, 10"

          "Super, semicolon, exec, workspace-action workspace"
          "Super Shift, semicolon, exec, workspace-action movetoworkspacesilent"
          "Super Shift, m, exec, workspace-rename"

          "Super Shift, n, togglegroup"
          "Super, N, changegroupactive"
          "Super, X, layoutmsg, togglesplit"

          "Shift Super Ctrl, H, movetoworkspacesilent, r-1" # Go to workspace on the left
          "Shift Super Ctrl, L, movetoworkspacesilent, r+1" # Go to workspace on the right

          # Navigate between workspaces with modifier + Alt + arrow keys
          "Super Ctrl, H, workspace, e-1" # Go to workspace on the left
          "Super Ctrl, L, workspace, e+1" # Go to workspace on the right

          # monitors
          "Super, W, focusmonitor, 0"
          "Super, E, focusmonitor, 1"
          "Super Shift, W, movecurrentworkspacetomonitor, 0"
          "Super Shift, E, movecurrentworkspacetomonitor, 1"

          # Move between monitors
          "Super, S, movecurrentworkspacetomonitor, l"
          "Super, D, movecurrentworkspacetomonitor, r"

          "Super, A, workspace, previous"

          "Super Alt, L, exec, hyprlock"

          "Super Ctrl, P, exec, flameshot gui"

          "Super Ctrl, SPACE, exec, dunstctl history-pop"
          "Super, B, exec, dunstctl close-all"
          "Super Shift, B, exec, dunstctl history-clear"

          "Super, c, togglespecialworkspace, audio"
          "Super, slash, togglespecialworkspace, journal"
          "Super, apostrophe, togglespecialworkspace, terminal"
          "Super Shift, T, togglespecialworkspace, ptpython"
          "Super Control, T, togglespecialworkspace, bluetooth"
          "Super Control, V, togglespecialworkspace, 1pw"

          "Super, F9, exec, toggle-bluetooth-audio"

          "Super, z, workspace, 10"
          "Super Shift, z, workspace, 8"
        ];

        workspace = [
          "2,defaultName:code"
          "3,defaultName:debug"
          "4,defaultName:fdc"
          "5,defaultName:gchat"
          "6,defaultName:private"
          "7,defaultName:web"
          "8,defaultName:meetings"
          "9,defaultName:nix"
          "10,defaultName:media"
          "11,defaultName:recruiting"

          #"w[t1], border:false" # don't draw borders if there is only one window
          "f[1],  border:false, gapsin:0, gapsout:0, rounding:false" # don't draw borders if we maximise one window
          "special:1pw, on-created-empty:1password"
          "special:audio, on-created-empty:pavucontrol"
          "special:bluetooth, on-created-empty:alacritty -e bluetuith"
          "special:journal, on-created-empty:scratchpad-journal"
          "special:ptpython, on-created-empty:alacritty -e ptpython"
          "special:terminal, on-created-empty:alacritty"
        ];

        windowrule = [
          # handle scratchpads
          "float, onworkspace:s[true]"
          #"maximize, move 50% 25%, size 50% 50%, onworkspace:s[true]"
          "move 44% 15%, onworkspace:s[true]"
          "size 55% 70%, onworkspace:s[true]"
        ];

        source = [
          "~/.config/hypr/monitors.conf"
        ];

        general = {
          gaps_in = 2;
          gaps_out = 2;
          border_size = 1;
          layout = "dwindle";
          resize_on_border = true;
        };

        misc = {
          disable_hyprland_logo = true;
        };

        monitor = ", preferred, auto, 1";

        decoration = {
          rounding = 5;
          blur = {
            special = false;
          };
        };

        #follow_mouse = 2; # focus follows on click

        dwindle = {
          pseudotile = true;
          preserve_split = true;
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

          follow_mouse = 2;
        };
        exec-once = [
          "waybar"
          #"iwgtk -i"

          #"blueman-applet"
          "gnome-keyring-daemon --start --components=secrets"
          "hyprdynamicmonitors run"
        ];
      };

      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };

    home.hyprdynamicmonitors = {
      enable = true;
      installExamples = false;
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

      chrome-wrapper

      pkgs.toggle-bluetooth-audio

      start-Hyprland
      notification-count
      pkgs.hyprdynamicmonitors

      scratchpad-journal
      workspace-action
      workspace-rename
    ];
  };
}
