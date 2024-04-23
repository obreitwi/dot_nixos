{
  lib,
  config,
  pkgs,
  dot-desktop,
  hostname,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./azure.nix
    ./disable-news.nix
    ./gui.nix
    ./neovim
    ./readline.nix
    ./shellPackages.nix
    ./tmuxPlugins.nix
    ./xmobar.nix
    ./xmonad.nix
    ./zellij.nix
    ./zsh.nix
  ];

  options.isNixOS = lib.mkEnableOption "Whether or not we run on nixOS";

  config = {
    my.neovim.neorg = false;

    home.packages = with pkgs;
      [
        backlight
        blobdrop

        # i3lock-fancy-rapid # not working in standalone
      ];

    home.username = "obreitwi";
    home.homeDirectory = "/home/obreitwi";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    programs.broot.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = false; # use fzf-tab instead
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";

    targets.genericLinux.enable = !config.isNixOS;

    home.sessionVariables = {
      FLAKE = "/home/obreitwi/git/dot_nixos";
      # EDITOR = "nvim";
    };
  };
}
