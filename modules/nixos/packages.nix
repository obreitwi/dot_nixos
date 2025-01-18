{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    unzip
  ];
}
