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

    # drag & drop from terminal
    blobdrop
    ripdrag

    # tools
    asfa
    ast-grep
    bat
    btop
    carapace
    dua
    duf
    fastgron
    gh
    miller
    pandoc
    silicon # make nice code screenshots
    zoxide
  ];
}
