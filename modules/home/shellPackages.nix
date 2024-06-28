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

    # disabled since not in use right now
    # k9s
    # kubecolor
    # kubectl

    circumflex # browser hackernews from terminal

    # formatter
    # nixpkgs-fmt # not used
    nixfmt-rfc-style
    alejandra

    # nix tooling
    update-nix-fetchgit

    # pen-and-paper tools
    haskellPackages.dice

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
    htop-vim
    miller
    numbat # scientific calculator
    pandoc
    progress
    shellcheck
    silicon # make nice code screenshots
    sttr # string conversions
    viddy
    zoxide

    # backup terminal if nixGL is out of date with GPU drivers
    st
  ];
}
