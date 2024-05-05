{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty
    autorandr
    feh # image viewer
    firefox
    nextcloud-client
    picom
    rofi
    rofimoji
    trayer
    xclip
    xss-lock
  ];
}
