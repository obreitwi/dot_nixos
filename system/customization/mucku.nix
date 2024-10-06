{pkgs, ...}: {
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

  hardware.sane.enable = true;

  # Getting scanner to work
  users.users.obreitwi.extraGroups = ["scanner" "lp"];
  hardware.sane.extraBackends = [pkgs.utsushi];
  services.udev.packages = [pkgs.utsushi];
}
