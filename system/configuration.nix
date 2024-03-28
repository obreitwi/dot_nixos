# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  pkgs-input,
  dot-desktop,
  ...
}: let
  tmuxPlugins = import ../modules/tmux-plugins.nix pkgs-unstable;
  shellPackages = import ../modules/shell-packages.nix {
    inherit pkgs pkgs-input pkgs-unstable;
  };
in {
  nixpkgs.config.permittedInsecurePackages = [
    "nix-2.16.2" # needed by nixd, is being worked on --2024-03-19
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

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

  # Configure keymap in X11
  services.xserver = {
    enable = true;

    autoRepeatDelay = 250;
    autoRepeatInterval = 30;

    libinput = {
      enable = true;

      # disabling mouse acceleration
      mouse = {accelProfile = "flat";};

      # disabling touchpad acceleration
      touchpad = {accelProfile = "flat";};
    };

    layout = "us";
    xkbVariant = "altgr-intl";
    xkbModel = "pc105";
    xkbOptions = "compose:menu compose:prsc lv3:ralt_switch eurosign:e nbsp:level3n caps:escape";

    desktopManager = {gnome = {enable = false;};};

    displayManager = {
      gdm.enable = false;

      lightdm.enable = true;
      defaultSession = "none+xmonad";
      # defaultSession = "myxmonad";

      session = [
        {
          manage = "desktop";
          name = "myxmonad";
          start = "exec $HOME/.xinitrc";
        }
      ];
    };

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };
  };

  services.earlyoom.enable = true;
  services.picom.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    localuser = null;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  services.openssh.enable = true;

  # TODO: apparenlty no service for dunst
  # services.dunst.enable = true; # notifications

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.obreitwi = {
    isNormalUser = true;
    description = "Oliver Breitwieser";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox

      # window manager
      xmobar

      #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # need all terminfos
  environment.enableAllTerminfo = true;
  environment.variables.EDITOR = "nvim";
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = ["DejaVuSansMono" "Iosevka" "IosevkaTerm" "Mononoki"];
    })
  ];

  environment.systemPackages = with pkgs;
    [
      # desktop environment
      alacritty
      autorandr
      earlyoom
      feh # image viewer
      rofi
      trayer
      xclip
      xss-lock

      # system package
      cmake
      gcc
    ]
    ++ shellPackages
    ++ tmuxPlugins;

  environment.etc."zsh/vi-mode.zsh".source = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
  environment.etc."tmux/load-plugins".text =
    lib.strings.concatMapStrings (p: "run-shell " + p.rtp + "\n") tmuxPlugins;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zsh.enable = true;

  # Some rograms need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.auto-optimise-store = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
