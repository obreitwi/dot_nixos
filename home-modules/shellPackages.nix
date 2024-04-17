{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # helper
    nh
    nvd
    nix-output-monitor

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
    ugrep

    # own stuff
    pydemx

    # dev
    diffoscope # fails to build with DeprecationWarning: PyPDF2 is deprecated. Please move to the pypdf library instead.
    gcc
    grpcurl
    k9s
    kubecolor
    kubectl
    nodejs

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
