{
  pkgs,
  pkgs-unstable,
  pkgs-input,
}: let
  tmuxPlugins = import ./tmux-plugins.nix pkgs-unstable;
in
  with pkgs-unstable; [
    # base setup
    bashInteractive
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
    killall
    lsd
    mr
    neovim # added by home-manager
    ripgrep
    ruby # only needed for neovim plugins
    tmux # + plugins
    tree-sitter
    ugrep
    zsh
    zsh-vi-mode

    # own stuff
    (callPackage (import "${pkgs-input.pydemx}") {}) # hacky way to include flake

    # dev
    gcc
    nodejs
    kubecolor
    kubectl
    k9s

    # lsps
    nixd
    nixpkgs-fmt
    alejandra

    # tools
    # pkgs-input.blobdrop  # not yet packaged
    btop
    dua
    duf
    gh
    # miller # useful tool
    ripdrag
    zoxide
  ]
