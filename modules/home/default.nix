{
  lib,
  config,
  ...
}: {
  imports = [
    ./options.nix

    ./atuin.nix
    ./azure.nix
    ./bat.nix
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
}
