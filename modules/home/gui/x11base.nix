{
  config,
  lib,
  pkgs,
  dot-desktop,
  hostname,
  ...
}: {
  options.my.gui.x11base.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.gui.x11base.enable) {
    home.file.".Xmodmap".source = "${dot-desktop}/x11/Xmodmap";
    home.file.".Xdefaults".text = ''
      Xft.dpi: 96
    '';

    home.file.".xinitrc" = {
      # text = lib.strings.concatStringsSep "\n" [
      # # ''
      # # #!/usr/bin/env bash

      # # export DBUS_SESSION_BUS_ADDRESS=$(systemctl --user show-environment | grep '^DBUS_SESSION_BUS_ADDRESS=' | tail -c +26)
      # # ''
      # (builtins.readFile "${dot-desktop}/x11/xinitrc")
      # ];
      source = "${dot-desktop}/x11/xinitrc";
    };

    home.packages = with pkgs; [
      backlight
      feh
      picom
      rofi
      xclip
      xdg-utils
      xterm

      # backup terminal if nixGL is out of date with GPU drivers
      st
    ];
  };
}
