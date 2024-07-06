{lib, pkgs-stable, ...}: {
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

  services.nginx.enable = true;

  services.openssh = {
    # openssh from unstable logs as sshd-session which causes fail2ban to not ban
    package = pkgs-stable.openssh;
  };

  # since nginx is the only consumer of acme certificates, simply add it to the acme group
  users.users.nginx.extraGroups = ["acme"];

  security.acme.certs = builtins.listToAttrs (map (domain: {
      name = domain;
      value = {
        domain = "*.${domain}";
        email = "admin+acme@${domain}";
        dnsProvider = "hetzner";

        # contains HETZNER_API_KEY=<key>
        environmentFile = "/var/lib/secrets/hetzner_dns.conf";

        postRun = "systemctl restart nginx";
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
