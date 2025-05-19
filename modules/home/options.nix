{
  config,
  lib,
  ...
}: {
  options.my.isNixOS = lib.mkEnableOption "Whether or not we run on nixOS";
  options.my.isMacOS = lib.mkEnableOption "Whether or not we run on Mac";

  options.my.username = lib.mkOption {
    type = lib.types.str;
  };

  config = {
    # home.packages = with pkgs; [
    # # i3lock-fancy-rapid # not working in standalone
    # ];

    home.username = config.my.username;
    home.homeDirectory =
      if config.my.username == "root"
      then "/root"
      else if config.my.isMacOS
      then "/Users/${config.my.username}"
      else "/home/${config.my.username}";

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";

    targets.genericLinux.enable = !config.my.isNixOS && !config.my.isMacOS;

    home.sessionVariables = {
      NH_FLAKE = "${config.home.homeDirectory}/git/dot_nixos";
    };

    programs.broot.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = false; # use fzf-tab instead
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.command-not-found.enable = false;
  };
}
