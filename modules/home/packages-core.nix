{
  pkgs,
  config,
  ...
}: {
  home.packages =
    [
      # nix helper
      pkgs.nh
      pkgs.nix-output-monitor
      pkgs.nixVersions.nix_2_28
      pkgs.nvd
      pkgs.nurl

      # base setup
      pkgs.bashInteractive
      pkgs.coreutils-full
      pkgs.curl
      pkgs.delta
      pkgs.gawk
      pkgs.gnused
      pkgs.killall
      pkgs.ripgrep
      pkgs.ugrep

      # json handling
      pkgs.jq
      pkgs.ijq
      pkgs.jo

      # nicer shell scripts
      pkgs.gum

      pkgs.dua
      pkgs.entr
      pkgs.viddy
      pkgs.zoxide
    ]
    ++ (
      if (!config.my.isMacOS)
      then [pkgs.inotify-tools]
      else []
    );
}
