{...}: {
  boot.loader.grub.device = "/dev/nvme0n1";

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  my.slock.enable = false;
  my.slock.patch = false;

  networking.firewall.enable = false;
}
