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

  # packages explicitly needed on mac to operate
  home.packages = [
    pkgs.gh

    pkgs.jdk
    pkgs.typst
    pkgs.typstyle

    # kubernetes tooling
    pkgs.k9s
    pkgs.kubecolor
    pkgs.kubectl
  ];
}
