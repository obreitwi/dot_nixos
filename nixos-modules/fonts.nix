{pkgs, ...}: {
  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = ["DejaVuSansMono" "Iosevka" "IosevkaTerm" "Mononoki"];
    })
  ];
}
