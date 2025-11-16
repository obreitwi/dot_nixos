# NOTE: should only be imported in mac-settings. Otherwise there are errors about missing configuration options not set in home-manager when built via nixOS.
# TODO: Avoid explicit imports, one config for everything should work without conditional imports.
{
  imports = [
    ./aerospace.nix
  ];
}
