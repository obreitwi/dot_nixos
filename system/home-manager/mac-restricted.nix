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

    # tech-stack
    pkgs.jdk
    pkgs.typst
    pkgs.typstyle
    pkgs.yarn

    # kubernetes tooling
    pkgs.kubectl
    pkgs.kubelogin

    #pkgs.inkscape # does not work (missing icons)

    pkgs.corkscrew

    # build docker
    pkgs.colima
    pkgs.docker
    pkgs.docker-compose
  ];
}
