{lib, ...}: {
  my.slock.enable = false;
  my.slock.patch = false;
  my.iwd.enable = false;

  my.gui.enable = false;

  my.server = {
    acme.staging = false;
    fail2ban.enable = true;
    nextcloud = {
      enable = true;
      hostName = "nc.zqnr.de";
    };
  };

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
