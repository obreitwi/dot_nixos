# home manager config only used on desktops not running nixOS
{...}: {
  imports = [
    ./common.nix
    ../../modules/home
    ../../modules/home/xsession
  ];

  my.isNixOS = false;

  programs.home-manager.enable = true;
  programs.nix-index-database.comma.enable = true;
  programs.nix-index.enable = true;
  programs.nix-index.enableZshIntegration = false;
}
