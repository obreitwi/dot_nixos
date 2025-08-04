{
  lib,
  config,
  pkgs,
  ...
}: {
  options.my.packages.extended = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.packages.extended {
    home.packages = with pkgs;
      [
        # own stuff
        asfa
        pydemx

        # dev
        # diffoscope # build error
        grpcurl

        dateutils
        moreutils

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

        # encode qr codes
        qrencode

        # videos
        mpv
        vlc
        yt-dlp

        # tools
        archivemount # mount archives as loopback
        ast-grep
        btop
        cloc
        duf
        entr
        ets # timestamps for commands
        fastgron
        fd
        findutils
        gh
        gifski # create hihg-quality GIFs
        gnumake
        gum # for shell scripts
        htop-vim
        hyperfine
        mergiraf
        miller
        mtr
        numbat # scientific calculator
        pandoc
        pkgs.stable.certbot-full
        progress # show progress of coretuils program (via external inspection)
        pv # progress visualizer
        silicon # make nice code screenshots
        spacer # spacer for command output
        speedtest-cli
        sttr # string conversions
        viddy
        zoxide
      ]
      ++ (
        if pkgs.stdenv.system == "x86_64-linux"
        then [
          # fzf based systemctl tui
          isd # trying out against sysz
          sysz # trying out against isd
          util-linux
        ]
        else []
      );
  };
}
