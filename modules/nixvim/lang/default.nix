{
  config,
  lib,
  ...
}: {
  imports = [
    ./cpp.nix
    ./go.nix
    ./haskell.nix
    ./rust.nix
    ./terraform.nix
    ./tex.nix
    ./toml.nix
    ./vimwiki.nix
  ];

  options.my.nixvim.lang.all = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };
}
