# home manager config for xmonad
{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-input,
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

    home.packages = with pkgs-unstable; [
      ttf-envy-code-r # xmobar
      trayer # xmonad
    ];

    programs.xmobar = {
      enable = true;
      extraConfig =
        builtins.readFile "${dot-desktop}/xmonad/xmobar.${hostname}";
    };
  };
}