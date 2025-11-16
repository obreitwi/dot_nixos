{lib, ...}: {
  imports = [
    ./firefox.nix
    ./packages.nix
    ./theming.nix
    ./udiskie.nix
    ./xserver.nix
  ];

  my.gui.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };
}
