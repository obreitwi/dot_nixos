{...}: {
  imports = [
    ./gui

    ./audio.nix
    ./firewall.nix
    ./fonts.nix
    ./locate.nix
    # ./gnupg.nix
    ./monitoring.nix
    ./networking.nix
    ./nextcloud.nix
    ./slock.nix
    ./tlp.nix
    ./xserver.nix
  ];
}
