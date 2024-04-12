# home manager config for xmonad
{
  lib,
  config,
  pkgs,
  dot-desktop,
  hostname,
  ...
}: {
  options.my.xmonad.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
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
      trayer # xmonad
    ];
  };
}
