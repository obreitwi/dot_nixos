# home manager config only used on desktops not running nixOS
{...}: {
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
}
