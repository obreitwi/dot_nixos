{
  config,
  ...
}: {
  services.keynav.enabled = config.isNixOS;
}
