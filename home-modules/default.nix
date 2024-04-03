{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  dot-desktop,
  hostname,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./disable-news.nix
    ./neovim.nix
    ./readline.nix
    ./shellPackages.nix
    ./tmuxPlugins.nix
    ./xmonad.nix
    ./zsh.nix
  ];

  options.isNixOS = lib.mkEnableOption "Whether or not we run on nixOS";

  config = {
    home.packages = with pkgs-unstable;
      [
        backlight
        blobdrop

        # i3lock-fancy-rapid # not working in standalone
      ];

    home.username = "obreitwi";
    home.homeDirectory = "/home/obreitwi";

    programs.zsh.enable = false; # will overwrite zshrc
    # programs.neovim.extraPackages = [ pkgs-unstable.gcc ];

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";

    targets.genericLinux.enable = !config.isNixOS;

    home.sessionVariables = {
      # EDITOR = "nvim";
    };
  };
}
