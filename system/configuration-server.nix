{
  config,
  pkgs,
  ...
}: let
  mdadmConf = ''
    HOMEHOST <ignore>
  '';
in {
  imports = [../modules/nixos];

  # Use GRUB2 as the boot loader.
  # We don't use systemd-boot because Hetzner uses BIOS legacy boot.
  boot.loader.systemd-boot.enable = false;

  # The mdadm RAID1s were created with 'mdadm --create ... --homehost=gentian',
  # but the hostname for each machine may be different, and mdadm's HOMEHOST
  # setting defaults to '<system>' (using the system hostname).
  # This results mdadm considering such disks as "foreign" as opposed to
  # "local", and showing them as e.g. '/dev/md/gentian:root0'
  # instead of '/dev/md/root0'.
  # This is mdadm's protection against accidentally putting a RAID disk
  # into the wrong machine and corrupting data by accidental sync, see
  # https://bugzilla.redhat.com/show_bug.cgi?id=606481#c14 and onward.
  # We do not worry about plugging disks into the wrong machine because
  # we will never exchange disks between machines, so we tell mdadm to
  # ignore the homehost entirely.
  environment.etc."mdadm.conf".text = mdadmConf;
  # The RAIDs are assembled in stage1, so we need to make the config
  # available there.
  boot.swraid.mdadmConf = mdadmConf;

  # Network (Hetzner uses static IP assignments, and we don't use DHCP here)
  networking.useDHCP = false;
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

  # Initial empty root password for easy login:
  # services.openssh.settings.PermitRootLogin = "prohibit-password";
  services.openssh.settings.PermitRootLogin = "no";
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  environment.systemPackages = with pkgs; [
    git
  ];

  system.stateVersion = "20.03"; # Did you read the comment?

  # need all terminfos
  environment.enableAllTerminfo = true;
  environment.variables.EDITOR = "nvim";
  environment.variables.LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
  environment.pathsToLink = ["/share/zsh"];

  users.users = {
    root = {
      initialHashedPassword = "";
    };
    obreitwi = {
      isNormalUser = true;
      description = "Oliver Breitwieser";
      extraGroups = ["networkmanager" "wheel"];
      shell = pkgs.zsh;
    };
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];

    max-jobs = "auto";
    cores = 0;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.supportedLocales = [
    "de_DE.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
  ];

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.zsh.enable = true;
  programs.command-not-found.enable = false;
}
