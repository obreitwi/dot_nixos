{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nextcloud-client
  ];

  # for nextcloud
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;
}
