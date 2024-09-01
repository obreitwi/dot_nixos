{
  lib,
  config,
  pkgs,
  pkgs-input,
  dot-desktop,
  hostname,
  ...
}: let
  xmonadrc = "x11/myxmonadrc";
in {
  options = {
    my.gui.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.my.gui.enable {
    console.useXkbConfig = true;
    # Configure keymap in X11
    services = {
      xserver = {
        enable = true;
        exportConfiguration = true;

        autoRepeatDelay = 250;
        autoRepeatInterval = 30;

        # TODO keep in sync with home manager config in x11base
        xkb = {
          layout = "us";
          variant = "altgr-intl";
          model = "pc105";
          options = lib.strings.concatStrings (
            lib.strings.intersperse " " ["compose:menu" "compose:prsc" "lv3:ralt_switch" "eurosign:e" "nbsp:level3n"]
            ++ (lib.optionals (hostname != "nimir") ["caps:escape"])
          );
        };

        desktopManager = {gnome = {enable = false;};};

        displayManager = {
          gdm.enable = false;

          lightdm.enable = true;

          session = [
            {
              manage = "desktop";
              name = "myxmonad";
              start = "exec /etc/${xmonadrc}";
            }
            {
              manage = "desktop";
              name = "startx";
              start = "startx";
            }
          ];
        };

        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };

      libinput = {
        enable = true;

        # disabling mouse acceleration
        mouse = {accelProfile = "flat";};

        # disabling touchpad acceleration
        touchpad = {accelProfile = "flat";};
      };
    };

    services.displayManager = {
      defaultSession = "myxmonad";
    };

    environment.etc."${xmonadrc}" = {
      source = "${dot-desktop}/x11/xinitrc";
    };

    home.packages = [pkgs.xdotool];
  };
}
