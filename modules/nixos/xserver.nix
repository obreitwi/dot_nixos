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
  console.useXkbConfig = true;
  # Configure keymap in X11
  services.xserver = {
    enable = true;
    exportConfiguration = true;

    autoRepeatDelay = 250;
    autoRepeatInterval = 30;

    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = {accelProfile = "flat";};

      # disabling touchpad acceleration
      touchpad = {accelProfile = "flat";};
    };

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
      ];
    };

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };

  services.displayManager = {
    defaultSession = "none+xmonad";
  };

  environment.etc."${xmonadrc}".source = "${dot-desktop}/x11/xinitrc";
}
