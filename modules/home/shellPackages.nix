{pkgs, ...}: {
  home.packages = with pkgs; [
    # nix helper
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
    archivemount # mount archives as loopback
    bat
    btop
    carapace
    cloc
    dua
    duf
    entr
    fastgron
    findutils
    fd
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
    util-linux
    viddy
    zoxide
  ];
}
