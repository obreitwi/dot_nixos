{
  config,
  lib,
  pkgs,
  dot-desktop,
  hostname,
  ...
}: let
  prepareBash =
    pkgs.writeShellScript "prepare-x11-env.sh"
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
              # Trying out xrender backend, 10-04-23 17:23:14
              # Tearing and windows disappearing, 22.04.2023 22:49:59
              # picom_args+=(--backend xrender)
          fi
          picom "''${picom_args[@]}"
      fi
    '';
in {
  options.my.gui.x11base.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.x11base.enable) {
    home.file.".Xmodmap".source = "${dot-desktop}/x11/Xmodmap";
    home.file.".Xdefaults".text = ''
      Xft.dpi: 96
    '';

    # home.file.".xinitrc" = {
    # # text = lib.strings.concatStringsSep "\n" [
    # # # ''
    # # # #!/usr/bin/env bash

    # # # export DBUS_SESSION_BUS_ADDRESS=$(systemctl --user show-environment | grep '^DBUS_SESSION_BUS_ADDRESS=' | tail -c +26)
    # # # ''
    # # (builtins.readFile "${dot-desktop}/x11/xinitrc")
    # # ];
    # source = "${dot-desktop}/x11/xinitrc";
    # };

    xsession = {
      enable = true;
      windowManager.command = lib.mkForce "nixGL xmonad";
      initExtra = ''
        bash ${prepareBash}

        # set wallpaper
        feh --bg-fill "$HOME/wallpaper/current"
        # lock screen
        if command -v xss-lock &>/dev/null; then
          xss-lock -- slock &
        fi

        # increase repeat rate
        xset rate 200 75
        # no beep
        xset b off

        # keynav &

        # no black x as cursor in tray
        xsetroot -cursor_name left_ptr
        if [ -f ~/.Xdefaults ]; then 
            xrdb ~/.Xdefaults &
        fi

        if command -v iwgtk &>/dev/null; then
            iwgtk -i &
        fi

        if command -v udiskie &>/dev/null; then
            udiskie --tray &
        fi

        # if command -v gnome-keyring-daemon &>/dev/null; then
            # source <(gnome-keyring-daemon --components=secrets -r -d | sed "s:^:export :g")
        # fi

        if command -v unclutter &>/dev/null; then
            killall unclutter
            unclutter &
        fi
      '';
    };

    # TODO sync with nixOS config
    home.keyboard = {
      layout = "us";
      variant = "altgr-intl";
      model = "pc105";
      options =
        ["compose:menu" "compose:prsc" "lv3:ralt_switch" "eurosign:e" "nbsp:level3n"]
        ++ (lib.optionals (hostname != "nimir") ["caps:escape"]);
    };

    home.packages = with pkgs; [
      arandr
      autorandr
      backlight
      feh
      glxinfo
      picom
      rofi
      unclutter
      xclip
      xdg-utils
      xterm

      # backup terminal if nixGL is out of date with GPU drivers
      st
    ];
  };
}
