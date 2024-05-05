{...}: {
  boot.loader.grub.device = "/dev/nvme0n1";
  networking.hostName = "mucku";

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = false;
      PasswordAuthentication = false;
    };
  };

  my.slock.patch = false;
}
