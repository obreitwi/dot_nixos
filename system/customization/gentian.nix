{lib, ...}: {
  my.slock.enable = false;
  my.slock.patch = false;
  my.iwd.enable = false;

  my.server.acme.staging = false;

  my.server.nextcloud = {
    enable = true;
    hostName = "nc.zqnr.de";
  };

  my.gui.enable = false;

  services.fail2ban.enable = true;

  security.acme.certs = builtins.listToAttrs (map (domain: {
      name = domain;
      value = {
        domain = "*.${domain}";
        email = "admin+acme@${domain}";
        dnsProvider = "hetzner";

        # contains HETZNER_API_KEY=<key>
        environmentFile = "/var/lib/secrets/hetzner_dns.conf";
      };
    }) [
      "zqnr.de"
      "initialcommit.org"
      "breitwieser.eu"
    ]);

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 443];
  };
}
