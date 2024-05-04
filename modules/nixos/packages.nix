{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty
    autorandr
    feh # image viewer
    firefox
    iwd
    picom
    rofi
    trayer
    xclip
    xss-lock
  ];
}
