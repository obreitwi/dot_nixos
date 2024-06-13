{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./azure.nix
    ./disable-news.nix
    ./dunst.nix
    ./git.nix
    ./gnupg.nix
    ./go.nix
    ./gui
    ./latex.nix
    ./neovim
    ./readline.nix
    ./revcli.nix
    ./shellPackages.nix
    ./terraform-ls.nix
    ./theming.nix
    ./tmux.nix
    ./wrepson.nix
    ./xmobar.nix
    ./xmonad.nix
    ./zathura.nix
    ./zellij.nix
    ./zsh.nix
  ];

  options.isNixOS = lib.mkEnableOption "Whether or not we run on nixOS";

  config = {
    my.neovim.neorg = true;

    home.packages = with pkgs; [
      backlight

      # i3lock-fancy-rapid # not working in standalone
    ];

    home.username = "obreitwi";
    home.homeDirectory = "/home/obreitwi";

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";

    targets.genericLinux.enable = !config.isNixOS;

    home.sessionVariables = {
      FLAKE = "/home/obreitwi/git/dot_nixos";
      # EDITOR = "nvim";
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

    programs.nix-index.enable = true;
  };
}
