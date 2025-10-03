{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nixvim.lang.nix = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.nix) {
    plugins.lsp = {
      servers = {
        nixd = {
          enable = true;
          settings = {
            diagnostic.suppress = ["sema-escaping-with"];
            formatting.command = [
              "${pkgs.alejandra}/bin/alejandra"
              "-qq"
            ];
            nixpkgs.expr = "import <nixpkgs> {}";
            options = {
              nixos = {
                expr = ''(builtins.getFlake "$NH_FLAKE").nixosConfigurations.gentian.options'';
              };
              home_manager = {
                expr = ''(builtins.getFlake "$NH_FLAKE").homeConfigurations."oliver.breitwieser@minir".options'';
              };
            };
          };
        };
      };
    };
  };
}
