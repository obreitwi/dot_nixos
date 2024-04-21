{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty
    autorandr
    earlyoom
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
