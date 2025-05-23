# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{pkgs, ...}: {
  imports = [../../modules/nixos];

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

  services.earlyoom.enable = true;
  services.picom = {
    enable = false;
    backend = "glx";
    settings = {
      xrender-sync-fence = "";
      daemon = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.unclutter.enable = true;
  services.unclutter.package = pkgs.stable.unclutter; # build issue (probably gcc14)

  services.openssh.enable = true;

  # need to enable when rolling own DE
  programs.dconf.enable = true;

  # TODO: apparenlty no service for dunst
  # services.dunst.enable = true; # notifications

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.obreitwi = {
    isNormalUser = true;
    description = "Oliver Breitwieser";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  # NOTE: Do not set nixpkgs.config here, it is set in flake.nix

  # need all terminfos
  environment.enableAllTerminfo = true;
  environment.variables.EDITOR = "nvim";
  environment.variables.LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
  environment.pathsToLink = ["/share/zsh"];
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zsh.enable = true;
  programs.command-not-found.enable = false;

  # Some rograms need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  environment.systemPackages = with pkgs; [
    poppler_utils
    usbutils
  ];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];

    max-jobs = "auto";
    cores = 0;
  };
}
