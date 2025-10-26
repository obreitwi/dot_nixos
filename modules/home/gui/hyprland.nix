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

  toggle-minimize = pkgs.writeShellApplication {
    name = "toggle-minimize";
    text = ''
      if hyprctl activewindow -j | jq --exit-status '.workspace.name | match("special:minimized")' >/dev/null; then
        # current window is minimized
        hyprctl dispatch movetoworkspace "$(hyprctl activeworkspace -j | jq -r .id)"
      else
        # current window is NOT minimized
        hyprctl dispatch movetoworkspacesilent special:minimized
      fi
    '';
  };

  waybar-uptime = pkgs.writeShellApplication {
    name = "waybar-uptime";
    text = ''
      UPTIME_FORMATTED=$(uptime | awk '{ print $3 }' | tr -d ',')

      echo " $UPTIME_FORMATTED"
    '';
  };

  chrome-wrapper = pkgs.writeShellApplication {
    name = "google-chrome";
    text = ''
      if [[ "''${XDG_BACKEND:-}" == wayland ]] && [ -f /usr/bin/google-chrome-stable ]; then
        #unset __EGL_VENDOR_LIBRARY_FILENAMES
        #unset LD_LIBRARY_PATH
        #unset GBM_BACKENDS_PATH

        # Alternatively: unset all egl related env variables and have chrome discover system libraries by default
        mapfile -t vars_to_unset < <(env | grep -i mesa | cut -d= -f1)
        unset "''${vars_to_unset[@]}"
      fi
      /usr/bin/google-chrome-stable --disable-features=WaylandWpColorManagerV1 "$@"
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

    # NOTE: On Ubuntu, Need to link /run/wrappers/bin/polkit-agent-helper-1
    services.hyprpolkitagent.enable = true;

    services.flameshot.enable = true;
    services.flameshot.settings.General.useGrimAdapter = true;
    services.flameshot.settings.General.disabledGrimWarning = true;

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

          "Super, W, layoutmsg, movetoroot"
          "Super Shift, W, layoutmsg, movetoroot active unstable"

          # Move focus with modifier + arrow keys
          "Super, H, exec, hyprnavi l"
          "Super, L, exec, hyprnavi r"
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
          "Super, T, layoutmsg, togglesplit"

          "Super Alt, H, movetoworkspacesilent, r-1" # Go to workspace on the left
          "Super Alt, L, movetoworkspacesilent, r+1" # Go to workspace on the right

          # monitors
          "Super, E, focusmonitor, 0"
          "Super, R, focusmonitor, 1"
          "Super Shift, E, movecurrentworkspacetomonitor, 0"
          "Super Shift, R, movecurrentworkspacetomonitor, 1"

          # Move between monitors
          "Super, S, swapactiveworkspaces, 0 1"

          "Super, A, workspace, previous"

          "Super Ctrl, L, exec, hyprlock"

          "Super Ctrl, P, exec, flameshot gui"

          "Super Ctrl, SPACE, exec, dunstctl history-pop"
          "Super, B, exec, dunstctl close-all"
          "Super Shift, B, exec, dunstctl history-clear"

          "Super, c, togglespecialworkspace, audio"
          "Super, slash, togglespecialworkspace, journal"
          "Super Ctrl, slash, setfloating"
          "Super Ctrl, slash, moveactive, exact 44% 15%"
          "Super Ctrl, slash, resizeactive, exact 55% 70%"
          "Super, apostrophe, togglespecialworkspace, terminal"
          "Super Shift, T, togglespecialworkspace, ptpython"
          "Super Control, T, togglespecialworkspace, bluetooth"
          "Super Control, V, togglespecialworkspace, 1pw"
          "Super Shift, D, togglespecialworkspace, minimized"
          "Super, D, exec, toggle-minimize"

          "Super, F9, exec, toggle-bluetooth-audio"

          "Super, z, workspace, 10"
          "Super Shift, z, workspace, 8"

          "Super Ctrl, i, exec, rofimoji -a copy"

          ", XF86MonBrightnessUp, exec, sbacklight +5%"
          ", XF86MonBrightnessDown, exec, sbacklight -5%"
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
          "12,defaultName:rust"
          "13,defaultName:root"

          #"w[t1], border:false" # don't draw borders if there is only one window
          "f[1],  border:false, gapsin:0, gapsout:0, rounding:false" # don't draw borders if we maximise one window
          "special:1pw,        on-created-empty:[float; move 44% 15%; size 55% 70%] 1password"
          "special:audio,      on-created-empty:[float; move 44% 15%; size 55% 70%] pavucontrol"
          "special:bluetooth,  on-created-empty:[float; move 44% 15%; size 55% 70%] alacritty -e bluetuith"
          "special:journal,    on-created-empty:[float; move 44% 15%; size 55% 70%] scratchpad-journal"
          "special:ptpython,   on-created-empty:[float; move 44% 15%; size 55% 70%] alacritty -e ptpython"
          "special:terminal,   on-created-empty:[float; move 44% 15%; size 55% 70%] alacritty"
          "special:minimized,  pass"
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
            "compose:rctrl "
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
          "sunsetr"

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

    programs.waybar = {
      enable = true;
      style = ../../../config-files/waybar/style.css;
      settings.mainBar = {
        layer = "top";
        position = "top";
        margin-left = -5;
        margin-right = -5;
        margin-top = -2;
        margin-bottom = -3;
        spacing = 0;
        modules-left = [
          "hyprland/workspaces"
          "custom/uptime"
          "hyprland/window"
        ];

        modules-center = [
          "clock"
        ];

        modules-right = [
          "custom/notifications"
          "tray"
          # "custom/pomodoro"
          "cpu"
          "memory"
          "temperature"
          "bluetooth"
          "network"
          "pulseaudio"
          "backlight"
          "battery"
        ];

        "hyprland/workspaces" = {
          # "format"= "{id}:{name} {icon}";
          "format" = "{id}:{name}";
          "format-icons" = {
            "active" = "";
            "default" = "";
          };
        };

        "hyprland/window" = {
          "on-click" = "toggle-minimize";
        };

        bluetooth = {
          "format" = "󰂲";
          "format-on" = "{icon}";
          "format-off" = "{icon}";
          "format-connected" = "{icon}";
          "format-icons" = {
            "on" = "󰂯";
            "off" = "󰂲";
            "connected" = "󰂱";
          };
          "on-click" = "alacritty -e bluetuith";
          "tooltip-format-connected" = "{device_enumerate}";
        };

        "custom/music" = {
          "format" = "  {}";
          "escape" = true;
          "interval" = 5;
          "tooltip" = false;
          "exec" = "playerctl metadata --format='{{ artist }} - {{ title }}'";
          "on-click" = "playerctl play-pause";
          "max-length" = 50;
        };

        clock = {
          timezone = "Europe/Berlin";
          tooltip = false;
          format = "{:%H:%M:%S  -  %A, %Y-%m-%d}";
          interval = 1;
        };

        temperature = {
          # "thermal-zone"= 2;
          #   "hwmon-path"= ["/sys/class/hwmon/hwmon2/temp1_input", "/sys/class/thermal/thermal_zone0/temp"];
          #   "critical-threshold"= 80;
          #   "format-critical"= "{temperatureC}°C ";
          format = "{temperatureC}°C ";
        };

        "network" = {
          format-wifi = "{icon}  {bandwidthDownBytes:=}  {bandwidthUpBytes:=}";
          format-ethernet = "{icon}  {bandwidthDownBytes:=}  {bandwidthUpBytes:=} ";
          format-disconnected = "󰤠 ";
          interval = 1;
          min-length = 16;
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          tooltip-format = "{essid} @ {ipaddr} ({signalStrength}%)";
          on-click = "iwgtk";
        };

        cpu = {
          interval = 1;
          format = "  {icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15} {usage:>2}%";
          format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          on-click = "alacritty -e btop";
        };

        memory = {
          interval = 30;
          format = "  {used:0.1f}G/{total:0.1f}G";
          tooltip-format = "Memory";
        };

        "custom/uptime" = {
          format = "{}";
          format-icon = [""];
          tooltip = false;
          interval = 60;
          exec = "${waybar-uptime}/bin/waybar-uptime";
        };

        "custom/notifications" = {
          format = "{}";
          tooltip = false;
          interval = 1;
          exec = "${notification-count}/bin/notification-count";
          on-click = "dunstctl history-pop";
          on-click-right = "dunstctl history-clear";
        };

        backlight = {
          format = "{icon}  {percent}%";
          format-icons = ["" "󰃜" "󰃛" "󰃞" "󰃝" "󰃟" "󰃠"];
          tooltip = false;
          "on-click" = "sbacklight +25%";
          "on-click-right" = "sbacklight -25%";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "";
          format-icons = {
            default = ["" "" " "];
          };
          on-click = "pavucontrol";
          on-click-right = "toggle-bluetooth-audio";
        };

        tray = {
          spacing = 10;
          icon-size = 18;
        };

        battery = {
          interval = 2;
          states = {
            # "good"= 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-full = "{icon}  {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          # "format-good"= ""; # An empty format will hide the module
          # "format-full"= "";
          format-icons = ["" "" "" "" ""];
        };

        "custom/lock" = {
          tooltip = false;
          on-click = "sh -c '(sleep 0s; hyprlock)' & disown";
          format = "";
        };

        "custom/pomodoro" = {
          format = "{}";
          return-type = "json";
          exec = "waybar-module-pomodoro --no-work-icons";
          on-click = "waybar-module-pomodoro toggle";
          on-click-right = "waybar-module-pomodoro reset";
        };
      };
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

    services.hyprsunset.enable = false; # has no automatic transitions -> use sunsetr instead

    home.file."${config.xdg.configHome}/systemd/user.conf" = {
      text = ''
        [Manager]
        ManagerEnvironment="XDG_DATA_DIRS=/usr/local/share:/usr/share:${config.xdg.stateHome}/nix/profile/share:${config.home.homeDirectory}/.nix-profile/share:/nix/var/nix/profiles/default/share"
      '';
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk config.wayland.windowManager.hyprland.finalPortalPackage];
      config = {
        hyprland = {
          default = ["hyprland" "gtk"];
          "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        };
      };
    };

    home.packages = [
      pkgs.blueman
      pkgs.nwg-displays
      pkgs.wev
      pkgs.wl-clipboard
      pkgs.wlprop
      pkgs.jq
      pkgs.hyprshot

      pkgs.sunsetr # has automatic location

      chrome-wrapper

      pkgs.toggle-bluetooth-audio

      start-Hyprland
      pkgs.hyprdynamicmonitors
      pkgs.hyprnavi

      scratchpad-journal
      toggle-minimize
      workspace-action
      workspace-rename
    ];
  };
}
