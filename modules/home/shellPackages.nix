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
    asfa
    pydemx

    # dev
    # diffoscope # build error
    grpcurl
    ijq
    jq
    k9s
    kubecolor
    kubectl

    circumflex # browser hackernews from terminal

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
    ast-grep
    bat
    btop
    carapace
    dua
    duf
    fastgron
    gh
    gum # for shell scripts
    miller
    pandoc
    silicon # make nice code screenshots
    sttr # string conversions
    zoxide
  ];
}
