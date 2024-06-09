# home manager config only used on desktops
{...}: {
  imports = [../modules/home ./common.nix];

  isNixOS = true;

  services.keynav.enable = true;
}
