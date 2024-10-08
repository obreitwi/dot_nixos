{
  lib,
  config,
  username,
  ...
}: {
  imports = [
    ./azure.nix
    ./disable-news.nix
    ./git
    ./gnupg.nix
    ./go.nix
    ./gui
    ./latex.nix
    ./libreoffice.nix
    ./lsd.nix
    ./lsp.nix
    ./neovim
    ./readline.nix
    ./revcli.nix
    ./shellPackages.nix
    ./terraform.nix
    ./tmux.nix
    ./work.nix
    ./wrepson.nix
    ./xsession
    ./zathura.nix
    ./zellij.nix
    ./zsh.nix
  ];

  options.my.isNixOS = lib.mkEnableOption "Whether or not we run on nixOS";

  config = {
    my.neovim.neorg = true;

    # home.packages = with pkgs; [
    # # i3lock-fancy-rapid # not working in standalone
    # ];

    home.username = username;
    home.homeDirectory = "/home/${username}";

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";

    targets.genericLinux.enable = !config.my.isNixOS;

    home.sessionVariables = {
      FLAKE = "/home/${username}/git/dot_nixos";
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

    # programs.nix-index.enable = true;
  };
}
