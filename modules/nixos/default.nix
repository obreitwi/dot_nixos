{lib, ...}: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./firewall.nix
    # ./gnupg.nix
    ./networking.nix
    ./nextcloud.nix
    ./packages.nix
    ./slock.nix
    ./tlp.nix
    ./xserver.nix
  ];
}
