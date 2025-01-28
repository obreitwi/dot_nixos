# home manager config only used on desktops not running nixOS
{...}: {
  imports = [../modules/home ../modules/home/xsession ./common.nix];

  my.isNixOS = false;

  programs.home-manager.enable = true;
  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;
  programs.nix-index.enableZshIntegration = false;
}
