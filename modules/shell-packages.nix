{ pkgs, pkgs-unstable, pkgs-input }:
let
  tmuxPlugins = import ./tmux-plugins.nix pkgs-unstable;
in
with pkgs-unstable; [
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
  pkgs-unstable.neovim
  ripgrep
  ruby # only needed for neovim plugins
  tmux # + plugins
  ugrep
  zsh
  zsh-vi-mode

  # own stuff
  (callPackage (import "${pkgs-input.pydemx}") { }) # hacky way to include flake

  # lsps
  nixd

  # tools
  pkgs-unstable.btop
  dua
  duf
  gh
  # miller # useful tool
  zoxide
]
