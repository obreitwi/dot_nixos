{pkgs, ...}: {
  fonts.enableDefaultPackages = true;
  # keep in sync with home manager fonts
  fonts.packages = with pkgs.nerd-fonts; [
    dejavu-sans-mono
    iosevka
    iosevka-term
    mononoki
  ];
}
