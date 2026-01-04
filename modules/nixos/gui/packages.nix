{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.my.gui.enable {
  environment.systemPackages = with pkgs; [
    alacritty
    feh # image viewer
    st
    rofi
    rofimoji
  ];
}
