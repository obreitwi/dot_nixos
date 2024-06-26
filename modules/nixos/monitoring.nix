{pkgs, ...}: {
  environment.systemPackages = [pkgs.htop-vim pkgs.smartmontools];
}
