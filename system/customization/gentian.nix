{
  pkgs-stable,
  myUtils,
  ...
}: let
  nginxDefault = domain:
    {
      extraConfig = ''
        disable_symlinks off;
      '';
      root = "/opt/www/default";

      locations."/frozen_synapse" = {
        extraConfig = ''
          autoindex on;
        '';
      };
    }
    // myUtils.nginxACME domain;
in {
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    devices = ["/dev/sda" "/dev/sdb"];
  };

  my.iwd.enable = false;

  my.gui.enable = false;

  my.server = {
    acme.staging = false;
    adminPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIATV2dhRTcF0n4H2cGRixu1q/P8hlsDULqzk1BS1VtxB";
    rootPubkeyEnable = true;
    fail2ban.enable = true;
    gitolite = {
      enable = true;
      hostName = "gitweb.zqnr.de";
      adminPubkey = "<not used since imported>";
    };
    nextcloud = {
      enable = true;
      hostName = "nextcloud.zqnr.de";
    };
  };

  services.openssh = {
    # openssh from unstable logs as sshd-session which causes fail2ban to not ban
    package = pkgs-stable.openssh;
  };

  # since nginx is the only consumer of acme certificates, simply add it to the acme group
  # nginx also needs to serve some paths from nextcloud directly
  users.users.nginx.extraGroups = ["acme" "nextcloud"];

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

  services.nginx = {
    enable = true;

    virtualHosts = {
      "zqnr.de" = nginxDefault "zqnr.de";
      "www.zqnr.de" = nginxDefault "zqnr.de";
      "gentian.zqnr.de" = nginxDefault "zqnr.de";
    };
  };
}
