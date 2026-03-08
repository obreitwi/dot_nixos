# home manager config only used on desktops not running nixOS
{hostname, ...}: {
  imports = [
    ./common.nix
    ../../modules/home/non-nixos
  ];

  my.isNixOS = false;
  my.gui.stylix.enable = false;
  my.gui.hyprland.enable = builtins.elem hostname ["minir"];

  programs.home-manager.enable = true;
  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;
  programs.nix-index.enableZshIntegration = false;
}
