{
  pkgs-stable,
  pkgs,
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
  imports = [
    ../../modules/nixos/server
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    devices = ["/dev/sda" "/dev/sdb"];
  };
  networking.interfaces."enp0s31f6".ipv4.addresses = [
    {
      address = "138.201.204.166";
      # FIXME: The prefix length is commonly, but not always, 24.
      # You should check what the prefix length is for your server
      # by inspecting the netmask in the "IPs" tab of the Hetzner UI.
      # For example, a netmask of 255.255.255.0 means prefix length 24
      # (24 leading 1s), and 255.255.255.192 means prefix length 26
      # (26 leading 1s).
      prefixLength = 26;
    }
  ];
  networking.interfaces."enp0s31f6".ipv6.addresses = [
    {
      address = "2a01:4f8:173:14a0::1";
      prefixLength = 64;
    }
  ];
  networking.defaultGateway = "138.201.204.129";
  networking.defaultGateway6 = {
    address = "fe80::1";
    interface = "enp0s31f6";
  };
  networking.nameservers = ["8.8.8.8"];

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

  users.users.vkarasen = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.bash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXgwQ23wvtnp8gkh6OUSP1I7SEfBMR4QYePWHhyl6eD default"
    ];
  };

  security.acme.certs = builtins.listToAttrs (map (domain: {
      name = domain;
      value = {
        domain = "*.${domain}";
        email = "admin+acme@${domain}";
        dnsProvider = "hetzner";

        # contains HETZNER_API_KEY=<key>
        environmentFile = "/var/lib/secrets/hetzner_dns.conf";

        postRun = "systemctl restart nginx postfix dovecot2";
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

      "initialcommit.org" = nginxDefault "initialcommit.org";
      "www.initialcommit.org" = nginxDefault "initialcommit.org";

      "github.breitwieser.eu" =
        {
          extraConfig = ''
            return 307 "https://github.com/obreitwi/";
          '';
        }
        // myUtils.nginxACME "breitwieser.eu";
      "breitwieser.eu" =
        nginxDefault "breitwieser.eu";
      "www.breitwieser.eu" = nginxDefault "breitwieser.eu";
    };
  };

  mailserver = let
    domains = ["breitwieser.eu" "initialcommit.org" "zqnr.de"];
    mailDomain = "breitwieser.eu";
    acme = myUtils.nginxACME mailDomain;
  in {
    enable = true;

    fqdn = "mail.${mailDomain}";
    inherit domains;

    certificateScheme = "manual";
    certificateFile = acme.sslCertificate;
    keyFile = acme.sslCertificateKey;

    loginAccounts."oliver@breitwieser.eu" = {
      hashedPasswordFile = "/var/lib/secrets/mail/obreitwi";
      catchAll = domains;
    };

    enablePop3 = true;
    enablePop3Ssl = true;
  };

  environment.systemPackages = with pkgs; [
    rrsync
  ];
}
