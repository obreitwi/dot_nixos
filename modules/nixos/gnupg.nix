# NOTE keep in sync with ../home/gnupg.nix
{pkgs, ...}: {
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;

    enableSSHSupport = true;
    enableExtraSocket = true;

    settings = {
      default-cache-ttl = 86400;
      default-cache-ttl-ssh = 86400;
      max-cache-ttl = 86400;
      max-cache-ttl-ssh = 86400;
    };
  };
}
