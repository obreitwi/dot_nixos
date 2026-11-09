{
  config,
  pkgs,
  lib,
  nixGL,
  ...
}: let
  start-hyprland = pkgs.writeShellApplication {
    name = "starth";
    text = ''
      unset LD_LIBRARY_PATH
      export QT_QPA_PLATFORM=wayland
      export GDK_BACKEND=wayland
      exec start-hyprland
    '';
  };

  hyprctl-disable-external-monitor = pkgs.writeShellApplication {
    name = "hyprctl-disable-external-monitor";
    text = ''
      hyprctl keyword monitor "$(hyprctl -j monitors  all | jq -r '.[] | select(.id == 1) | .name'),disable"
    '';
  };

  toggle-minimize = pkgs.writeShellApplication {
    name = "toggle-minimize";
    text = ''
      if hyprctl activewindow -j | jq --exit-status '.workspace.name | match("special:minimized")' >/dev/null; then
        # current window is minimized
        hyprctl dispatch "hl.dsp.window.move{{ workspace = $(hyprctl activeworkspace -j | jq -r .id) })"
      else
        # current window is NOT minimized
        hyprctl dispatch 'hl.dsp.window.move({ workspace = "special:minimized", follow = false })'
      fi
    '';
  };

  waybar-uptime = pkgs.writeShellApplication {
    name = "waybar-uptime";
    text = ''
      UPTIME_FORMATTED=$(uptime | cut -d, -f 1 | sed -e "s:.*up\s*::")

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

  hyprmoncfg = pkgs.hyprmoncfg.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.installShellFiles];

    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        $out/bin/hyprmoncfg completion zsh > _hyprmoncfg.zsh
        $out/bin/hyprmoncfgd completion zsh > _hyprmoncfgd.zsh

        installShellCompletion --zsh _hyprmoncfg.zsh
        installShellCompletion --zsh _hyprmoncfgd.zsh
      '';
  });

  # Start hyprmoncfgd for 10 seconds to generate new config
  hyprmoncfg-apply = pkgs.writeShellApplication {
    name = "hyprmoncfg-apply";
    text = ''
      hyprmoncfgd &
      pid=$!
      sleep 10
      kill "$pid"
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

  window-swap = pkgs.writeShellApplication {
    name = "window-swap";
    text = ''
      windows=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name | startswith("special:") | not) |  [.address, .title + " (" + .workspace.name + ")" ] | @tsv')

      swap_target=$( \
        ( echo "''${windows}" ) \
          | sort | uniq \
          | rofi -dmenu -match-only -display-columns 2 -display-column-separator "\t" -p "Window to swap" \
          | awk -F "\t" '{ print $1 }'
      )
      hyprctl dispatch "hl.dsp.window.swap({ target = \"address:''${swap_target}\" })"
    '';
  };

  workspace-action = pkgs.writeShellApplication {
    name = "workspace-action";
    text = ''
      action="''$1"
      shift 1

      default_targets=$(hyprctl workspacerules -j | jq -r '.[] | select(.defaultName != null) | [.workspaceString, .defaultName] | @tsv')
      custom_targets=$(hyprctl workspaces -j | jq -r '.[] | select(.name | startswith("special:") | not) | [.id, .name] | @tsv')

      jump_target=$( \
        ( echo "''${default_targets}"; echo "''${custom_targets}" ) \
          | sort -n | uniq \
          | rofi -dmenu -match-only -display-columns 2 -display-column-separator "\t" -p "Workspace" \
          | awk -F "\t" '{ print $1 }'
      )

      case "''${action}" in
        "focus")
          dispatcher="hl.dsp.focus({ workspace = \"''${jump_target}\" })"
          ;;
        "move")
          dispatcher="hl.dsp.window.move({ workspace = \"''${jump_target}\", follow = false })"
          ;;
        *)
          exit 1
          ;;
      esac
      hyprctl dispatch "''${dispatcher}"
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
    targets.genericLinux.nixGL = lib.mkIf (!config.my.isNixOS) {
      packages = nixGL.packages; # you must set this or everything will be a noop
      defaultWrapper = "mesa"; # choose from nixGL options depending on GPU
    };

    # NOTE: On Ubuntu, Need to link /run/wrappers/bin/polkit-agent-helper-1
    services.hyprpolkitagent.enable = true;

    services.flameshot.enable = true;
    #services.flameshot.settings.General.useGrimAdapter = true;
    #services.flameshot.settings.General.disabledGrimWarning = true;

    wayland.windowManager.hyprland = {
      configType = "lua";

      enable = true;
      package =
        if (config.my.isNixOS)
        then pkgs.hyprland
        else config.lib.nixGL.wrap pkgs.hyprland;

      xwayland.enable = true;

      extraLuaFiles = {
        config = {
          autoLoad = true;
          content = ./hyprland.lua;
        };

        startup = {
          autoLoad = true;
          content =
            /*
            lua
            */
            ''
              hl.on("hyprland.start", function()
                  hl.exec_cmd("waybar")
                  hl.exec_cmd("sunsetr")
                  hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
                  hl.exec_cmd("hyprmoncfgd")
                  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme '${config.home.pointerCursor.name}'")
                  hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size ${toString config.home.pointerCursor.size}")
              end)
            '';
        };
      };

      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };

    services.hyprpaper = {
      enable = true;

      settings = {
        splash = false;

        wallpaper = [
          {
            path = "${config.home.homeDirectory}/wallpaper/current";
            monitor = "";
          }
        ];
      };
    };

    programs.waybar = {
      enable = true;
      style = lib.mkForce ../../../../config-files/waybar/style.css;
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
          "custom/lock"
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
      settings = lib.mkForce {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };

        animations = {
          enabled = true;
          fade_in = {
            #duration = 300;
            bezier = "easeOutQuint";
          };
          fade_out = {
            #duration = 300;
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

    home.file."${config.xdg.configHome}/rofimoji.rc" = {
      text = ''
        files = [arrows, miscellaneous_symbols, latin-1_supplement, letterlike_symbols, emojis_smileys_emotion, emojis_people_body, emojis_animals_nature, emojis_food_drink, emojis_activities, emojis_travel_places, emojis_objects, emojis_symbols, emojis_flags]
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

    stylix = {
      targets.hyprland.enable = true;
    };

    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;

      hyprcursor.enable = true;
    };

    programs.zsh.initContent =
      /*
      zsh
      */
      ''
        restart_hyprlock() {
          killall hyprlock
          sleep 1
          hyprctl --instance 0 "keyword misc:allow_session_lock_restore 1"
          hyprctl --instance 0 "dispatch exec hyprlock"
        }
      '';

    home.packages = [
      pkgs.blueman
      pkgs.hyprshot
      pkgs.jq
      pkgs.nwg-displays
      pkgs.wev
      pkgs.wl-clipboard
      pkgs.wlr-randr
      pkgs.wlprop

      pkgs.sunsetr # has automatic location

      chrome-wrapper

      pkgs.toggle-bluetooth-audio

      start-hyprland
      hyprmoncfg
      hyprmoncfg-apply

      pkgs.rofi
      pkgs.rofimoji
      pkgs.rofi-bluetooth

      hyprctl-disable-external-monitor
      scratchpad-journal
      toggle-minimize
      window-swap
      workspace-action
      workspace-rename
    ];
  };
}
