{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alacritty
    autorandr
    feh # image viewer
    firefox
    picom
    rofi
    trayer
    xclip
    xss-lock
  ];
}
