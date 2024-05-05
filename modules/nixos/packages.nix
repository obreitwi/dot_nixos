{pkgs, ...}: {
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
