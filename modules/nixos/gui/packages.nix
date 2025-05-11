{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.my.gui.enable {
  environment.systemPackages = with pkgs; [
    alacritty
    autorandr
    feh # image viewer
    picom
    st
    rofi
    rofimoji
    trayer
    xclip
    xss-lock
  ];
}
