{lib, ...}: {
  imports = [
    ./apl.nix
    ./cpp.nix
    ./css.nix
    ./dart.nix
    ./go.nix
    ./haskell.nix
    ./java.nix
    ./postgres.nix
    ./python.nix
    ./rust.nix
    ./terraform.nix
    ./tex.nix
    ./toml.nix
    ./typescript.nix
    ./typst.nix
    ./vimwiki.nix
  ];

  options.my.nixvim.lang.all = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };
}
