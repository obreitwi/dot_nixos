{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  boot.loader.grub.device = "/dev/nvme0n1";
  networking.hostName = "mucku";

  my.slock.patch = true;
}
