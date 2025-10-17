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
        debug.disable_logs = false; # TODO: Enable once done.

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

          "Shift Super Ctrl, H, movetoworkspace, e-1" # Go to workspace on the left
          "Shift Super Ctrl, L, movetoworkspace, e+1" # Go to workspace on the right

          # Navigate between workspaces with modifier + Alt + arrow keys
          "Super Ctrl, H, workspace, e-1" # Go to workspace on the left
          "Super Ctrl, L, workspace, e+1" # Go to workspace on the right

          # Move between monitors
          "Super, S, movecurrentworkspacetomonitor, l"
          "Super, D, movecurrentworkspacetomonitor, r"
        ];

        general = {
          gaps_in = 2;
          gaps_out = 2;
          border_size = 1;
          layout = "dwindle";
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

        # TODO: hyprlock
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

    home.file."${config.xdg.configHome}/waybar/config" = {
      source = ../../../config-files/waybar/config.jsonc;
    };
    home.file."${config.xdg.configHome}/waybar/uptime.sh" = {
      text =
        /*
        bash
        */
        ''
          #!/bin/bash
          UPTIME_PRETTY=$(uptime -p)

          UPTIME_FORMATTED=$(echo "$UPTIME_PRETTY"| sed 's/^up //;s/,*$//;s/minute/m/; s/hour/h/; s/day/d/; s/s//g')

          echo " $UPTIME_FORMATTED"
        '';
    };
    programs.waybar = {
      enable = true;
      style = ../../../config-files/waybar/style.css;
      #settings.mainBar = {
      ## ~/.config/nixpkgs/waybar.nix (Example file structure)
      ## This snippet is designed to be used within Home Manager's waybar.settings option

      ## Top-level Waybar settings
      #layer = "top";
      #position = "top";
      #spacing = 5;
      #height = 30;
      #"margin-top" = 0;
      #"margin-bottom" = 0;
      #"margin-left" = 0;
      #"margin-right" = 0;

      ## Module layout
      #"modules-left" = [
      #"hyprland/workspaces"
      #"hyprland/window"
      #];
      #"modules-center" = [
      #"clock"
      #];
      #"modules-right" = [
      #"battery"
      #"network"
      #"pulseaudio"
      #"tray"
      #];

      ## Module-specific configurations
      #"hyprland/workspaces" = {
      #format = "{icon}";
      #"format-icons" = {
      #default = "•";
      #active = "󰮯";
      #persistent = "󰂚";
      #};
      ##"sort-by" = "id";
      #};

      #"hyprland/window" = {
      #"max-length" = 50;
      #tooltip = true;
      #};

      #clock = {
      #format = " {:%a %b %d}  |   {:%H:%M}";
      #"tooltip-format" = "<big>{:%Y %B}</big>\\n<tt><small>{:I:%M %p}</small></tt>";
      ## Note: '\\n' is used for a newline in Nix strings that will be interpreted as '\n' in the final JSON.
      #};

      #battery = {
      #format = "{icon} {capacity}%";
      #"format-charging" = "󰢋 {capacity}%";
      #"format-plugged" = "󰢟 {capacity}%";
      #"format-alt" = "{time} {icon}";
      #"format-icons" = [
      #"󰂎"
      #"󰁽"
      #"󰁿"
      #"󰁾"
      #"󰂀"
      #"󰂁"
      #"󰂂"
      #"󰂃"
      #"󰂄"
      #"󰂅"
      #"󰂇"
      #];
      #states = {
      #good = 90;
      #warning = 30;
      #critical = 15;
      #};
      #};

      #network = {
      #"format-wifi" = " {essid}";
      #"format-ethernet" = "󰈀 {ipaddr}/{cidr}";
      #"format-disconnected" = "󰤮 Disconnected";
      #};

      #pulseaudio = {
      #format = "󰕾 {volume}%";
      #"format-muted" = "󰖁 Muted";
      #"scroll-step" = 5;
      #"on-click" = "pavucontrol";
      #};

      #tray = {
      #"icon-size" = 18;
      #spacing = 10;
      #};
      #};
    };

    services.hyprsunset.enable = true;

    #home.pointerCursor.hyprcursor.enable = true;

    home.packages = [
      pkgs.blueman
      pkgs.nwg-displays
      pkgs.wev
      pkgs.wl-clipboard
      pkgs.wlprop
    ];
  };
}
