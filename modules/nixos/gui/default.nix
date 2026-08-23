{lib, ...}: {
  imports = [
    ./firefox.nix
    ./hyprland.nix
    ./packages.nix
    ./theming.nix
    ./udiskie.nix
  ];

  options.my.gui.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };
}
