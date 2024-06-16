{pkgs, ...}: {
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
    gnumake
    gnused
    killall
    lsd
    mr
    ripgrep
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
    marksman
    nixd
    bash-language-server

    # formatter
    # nixpkgs-fmt # not used
    nixfmt-rfc-style
    alejandra

    # nix tooling
    update-nix-fetchgit

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

    # backup terminal if nixGL is out of date with GPU drivers
    st
  ];
}
