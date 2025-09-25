# home manager config only used on desktops not running nixOS
{pkgs, ...}: {
  imports = [
    ./common.nix
  ];

  my = {
    isNixOS = false;
    isMacOS = true;

    gui.enable = false;
    gui.fonts.enable = true;

    atuin.enable = true;

    gnupg.enable = false;
    go.enable = false;

    lsp.all = false;

    packages.extended = false;
  };

  programs = {
    kubecolor = {
      enable = true;
      enableAlias = true;
      enableZshIntegration = true;
    };
    k9s.enable = true;
  };

  # packages explicitly needed on mac to operate
  home.packages = [
    pkgs.gh

    pkgs.flameshot

    pkgs.duf

    # tech-stack (supplied via shell.ni)
    # backend
    #pkgs.jdk
    #pkgs.typst
    #pkgs.typstyle

    # frontend
    #pkgs.yarn
    #pkgs.nodejs_20

    # kubernetes tooling
    pkgs.kubectl
    pkgs.kubelogin
    pkgs.yq

    # database
    pkgs.postgresql

    #pkgs.inkscape # does not work (missing icons)

    pkgs.corkscrew

    # dev tooling
    pkgs.mergiraf

    # build docker
    pkgs.colima
    pkgs.docker
    pkgs.docker-compose

    pkgs.gnupg
    pkgs.p7zip
  ];
}
