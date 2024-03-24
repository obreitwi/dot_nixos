# home manager config for xmonad
{ lib, config, pkgs, pkgs-unstable, pkgs-input, isNixOS, dot-desktop, hostname
, ... }: {
  home.file."${config.home.homeDirectory}/.xmonad/lib" = {
    source = "${dot-desktop}/xmonad/lib";
    recursive = true;
  };
  home.file."${config.home.homeDirectory}/.xmonad/xmonad.hs" = {
    source = "${dot-desktop}/xmonad/xmonad.hs";
  };
  home.file."${config.home.homeDirectory}/.xmonad/xmobar" = {
    source = "${dot-desktop}/xmonad/xmobar.${hostname}";
  };

  home.packages = with pkgs-unstable; [
    ttf-envy-code-r # xmoba
    trayer # xmonad
  ];

  programs.xmobar = {
    enable = true;
    extraConfig =
      (builtins.readFile "${dot-desktop}/xmonad/xmobar.${hostname}");
  };
}
