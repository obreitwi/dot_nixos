{...}: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./firewall.nix
    # ./gnupg.nix
    ./monitoring.nix
    ./networking.nix
    ./nextcloud.nix
    ./packages.nix
    ./slock.nix
    ./tlp.nix
    ./xserver.nix
  ];
}
