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
    diffoscope
    grpcurl
    ijq
    jq
    k9s
    kubecolor
    kubectl

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
    miller
    ripdrag
    zoxide
  ];
}
