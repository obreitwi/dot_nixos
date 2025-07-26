# home manager config only used on desktops not running nixOS
{...}: {
  imports = [
    ./common.nix
  ];

  my.isNixOS = false;
  my.gui.stylix.enable = false;

  programs.home-manager.enable = true;
  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;
  programs.nix-index.enableZshIntegration = false;
}
