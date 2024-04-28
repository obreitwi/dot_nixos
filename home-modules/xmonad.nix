# home manager config for xmonad
{
  lib,
  config,
  pkgs,
  dot-desktop,
  ...
}: 
let
 inherit (config.my.stalonetray) slot-size num-icons;
in
{
  options.my.xmonad.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  options.my.stalonetray = {
    num-icons = lib.mkOption {
      default = 6;
      type = lib.types.int;
    };

    slot-size = lib.mkOption {
      default = 17;
      type = lib.types.int;
    };
  };

  config = lib.mkIf config.my.xmonad.enable {
    home.file."${config.home.homeDirectory}/.xmonad/lib" = {
      source = "${dot-desktop}/xmonad/lib";
      recursive = true;
    };

    home.file."${config.home.homeDirectory}/.xmonad/xmonad.hs" = {
      source = "${dot-desktop}/xmonad/xmonad.hs";
    };

    home.packages = with pkgs; [
      toggle-bluetooth-audio
      trayer # xmonad
    ];

    services.stalonetray = {
      enable = true;
      config = {
        # back background
        background = "#000000";
        # 8 size icons with padding
        icon_size = "${toString (slot-size - 1)}";
        slot_size = "${toString slot-size}";
        # up to ten icons in top right corner
        geometry = "${toString num-icons}x1-0+0";
        # icons are on the right
        icon_gravity = "E";
        skip_taskbar = true;
        # force icon sizes
        kludges = "force_icons_size";
        # xmonad handles that
        window_strut = "none";
      };
    };
  };
}
