{
  config,
  hostname,
  dot-desktop,
  lib,
  pkgs,
  ...
}: let
  # TODO sync with autorand
  startPicom = pkgs.writeShellApplication {
    name = "start-picom";
    runtimeInputs = [
      pkgs.picom
      pkgs.glxinfo
    ];
    text = ''
      picom_args=(-b)

      if lsmod | grep -q '^amdgpu'; then
        picom_args=(--backend xrender)
      else
        picom_args=(--backend glx)
      fi

      # If we use nvidia as the main renderer -> compose with glx backend and render fence
      if [[ "$(hostname)" == "mimir" ]] && [ "$(glxinfo | grep "OpenGL renderer")" = "OpenGL renderer string: NVIDIA RTX A1000 Laptop GPU/PCIe/SSE2" ]; then
        picom_args+=(--xrender-sync-fence)
      fi
      picom "''${picom_args[@]}"
    '';
  };

  # ptpython shell for small calculations that does not leak its whole environment
  ptpython = let
    wrapped = pkgs.python3.withPackages (ps: [
      ps.numpy
      ps.scipy
      pkgs.python3Packages.ptpython
    ]);
  in
    pkgs.writeShellApplication {
      name = "ptpython";
      runtimeInputs = [wrapped];
      text = ''
        ${wrapped}/bin/ptpython "$@"
      '';
    };

  xsession-non-nixOS =
    # sh
    ''
      # lock screen
      if command -v xss-lock &>/dev/null; then
        xss-lock -- slock &
      fi

      if command -v unclutter &>/dev/null; then
          killall unclutter &>/dev/null
          unclutter &
      fi

      # TODO: properly handle this via systemd-xdg-autostart-generator
      if [ -e /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ]; then
          /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
      fi
    '';

  xsession-both =
    # sh
    ''
      # increase repeat rate
      # args are <delay in ms after which to start repeating key> <repeat rate>
      xset r rate 400 40
      # no beep
      xset b off

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

      if [ -f ~/.Xmodmap ]; then
        xmodmap ~/.Xmodmap
      fi

      # set wallpaper
      feh --bg-fill "$HOME/wallpaper/current"

      if command -v nixGL &>/dev/null; then
        nixGL start-picom
      else
        start-picom
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

    xsession = {
      enable = true;
      windowManager = lib.mkIf (!config.my.isNixOS) {
        command = lib.mkForce "nixGL xmonad";
      };
      initExtra = lib.strings.concatLines (
        (lib.optionals (!config.my.isNixOS) [xsession-non-nixOS]) ++ [xsession-both]
      );
    };

    # TODO sync with nixOS config
    home.keyboard = lib.mkIf (!config.my.isNixOS) {
      layout = "us";
      variant = "altgr-intl";
      model = "pc105";
      options =
        [
          "compose:menu"
          "compose:prsc"
          "lv3:ralt_switch"
          "eurosign:e"
          "nbsp:level3n"
        ]
        ++ (lib.optionals (hostname != "nimir") ["caps:escape"]);
    };

    home.packages = with pkgs;
      [
        arandr
        autorandr
        backlight
        feh
        glxinfo
        picom
        rofi
        xclip
        xdg-utils
        xorg.xmodmap
        xterm

        startPicom

        # backup terminal if nixGL is out of date with GPU drivers
        st
      ]
      ++ [
        ptpython
        pkgs.stable.unclutter
      ]; # unclutter: build issue (probably gcc14)
  };
}
