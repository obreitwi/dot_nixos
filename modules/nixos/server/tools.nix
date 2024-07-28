{pkgs, ...}: {
  # tools needed system-wide
  environment.systemPackages = with pkgs; [
    bat
    dua
    fd
    openssl
  ];
}
