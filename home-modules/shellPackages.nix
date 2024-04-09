{
  config,
  lib,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable; [
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
    # neovim # added by home-manager
    ripgrep
    ruby # only needed for neovim plugins
    tmux # + plugins
    tree-sitter
    ugrep

    # own stuff
    pydemx

    # dev
    diffoscope # fails to build with DeprecationWarning: PyPDF2 is deprecated. Please move to the pypdf library instead.
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
  ];
}
