{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  boot.loader.grub.device = "/dev/sda";
  networking.hostName = "nimir";

  my.slock.patch = true;
}
