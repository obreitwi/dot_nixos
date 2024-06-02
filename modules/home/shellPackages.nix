{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # helper
    nh
    nix-output-monitor
    nixVersions.nix_2_22
    nvd

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
    (callPackage (import ../../packages/asfa.nix) {})
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

    terraform

    # lsps
    gopls
    marksman
    nixd
    nodePackages.bash-language-server

    # formatter
    nixpkgs-fmt
    alejandra

    # pen-and-paper tools
    haskellPackages.dice

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
    findutils
    gh
    gifski # create hihg-quality GIFs
    gum # for shell scripts
    miller
    numbat # scientific calculator
    pandoc
    shellcheck
    silicon # make nice code screenshots
    sttr # string conversions
    zoxide
  ];
}
