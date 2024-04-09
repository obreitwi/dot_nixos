{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty
    autorandr
    earlyoom
    feh # image viewer
    firefox
    rofi
    picom
    trayer
    xclip
    xss-lock
  ];
}
