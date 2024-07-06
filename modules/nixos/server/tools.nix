{pkgs, ...}: {
  # tools needed system-wide
  environment.systemPackages = with pkgs; [
    dua
  ];
}
