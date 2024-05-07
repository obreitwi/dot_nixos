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
    # diffoscope # build error
    grpcurl
    ijq
    jq
    k9s
    kubecolor
    kubectl

    # lsps
    gopls
    nixd

    # formatter
    nixpkgs-fmt
    alejandra

    # tools
    ast-grep
    bat
    blobdrop
    btop
    carapace
    dua
    duf
    fastgron
    gh
    miller
    pandoc
    ripdrag
    silicon # make nice code screenshots
    zoxide
  ];
}
