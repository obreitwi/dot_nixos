{lib, ...}: {
  imports = [
    ./apl.nix
    ./css.nix
    ./cpp.nix
    ./dart.nix
    ./go.nix
    ./haskell.nix
    ./java.nix
    ./python.nix
    ./rust.nix
    ./terraform.nix
    ./tex.nix
    ./toml.nix
    ./typst.nix
    ./vimwiki.nix
  ];

  options.my.nixvim.lang.all = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };
}
