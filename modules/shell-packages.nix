{ inputPkgs, pkgs }:
let
  tmuxPlugins = import ./tmux-plugins.nix pkgs;
in
with pkgs; [
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
  neovim
  ripgrep
  ruby # only needed for neovim plugins
  tmux # + plugins
  ugrep
  zsh
  zsh-vi-mode

  # own stuff
  (callPackage (import "${inputPkgs.pydemx}") { }) # hacky way to include flake

  # lsps
  nixd

  # tools
  dua
  duf
  gh
  # miller # useful tool
  zoxide
]
