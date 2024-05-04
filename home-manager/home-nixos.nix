# home manager config only used on desktops
{
  ...
}: {
  imports = [../modules/home];

  isNixOS = true;

  services.keynav.enable = true;
}
