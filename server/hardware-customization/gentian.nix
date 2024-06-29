{...}: {
  my.slock.enable = false;
  my.slock.patch = false;
  my.iwd.enable = false;

  my.server.acme.enable = true;
  my.server.acme.staging = false;

  services.fail2ban.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443];
  };
}
