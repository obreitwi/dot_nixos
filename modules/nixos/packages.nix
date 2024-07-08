{lib, config, pkgs, ...}: lib.mkIf config.my.gui.enable {
  environment.systemPackages = with pkgs; [
    alacritty
    autorandr
    feh # image viewer
    firefox
    picom
    rofi
    rofimoji
    trayer
    xclip
    xss-lock
  ];
}
