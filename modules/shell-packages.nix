{ pkgs, pkgs-unstable, pkgs-input }:
let tmuxPlugins = import ./tmux-plugins.nix pkgs-unstable;
in with pkgs-unstable; [
  # base setup
  bash
  bat
  carapace
  coreutils-full
  curl
  delta
  fzf
  gawk
  git
  gnumake
  gnused
  lsd
  mr
  neovim # added by home-manager
  tree-sitter
  ripgrep
  ruby # only needed for neovim plugins
  tmux # + plugins
  ugrep
  zsh
  zsh-vi-mode

  # own stuff
  (callPackage (import "${pkgs-input.pydemx}") { }) # hacky way to include flake

  # dev
  gcc
  nodejs

  # lsps
  nixd

  # tools
  btop
  dua
  duf
  gh
  # miller # useful tool
  zoxide
]
