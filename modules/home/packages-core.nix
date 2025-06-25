{pkgs, ...}: {
  home.packages = with pkgs; [
    # nix helper
    nh
    nix-output-monitor
    nixVersions.nix_2_28
    nvd
    nurl

    # base setup
    bashInteractive
    coreutils-full
    curl
    delta
    gawk
    gnused
    killall
    ripgrep
    ugrep

    inotify-tools

    # json handling
    jq
    ijq
    jo

    # nicer shell scripts
    gum

    dua
    entr
    viddy
    zoxide
  ];
}
