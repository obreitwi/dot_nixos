{
  config,
  lib,
  ...
}: {
  options.my.nixvim.lsp = {
    common = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.my.nixvim.lsp.common {
    plugins.lsp = {
      servers = {
        eslint = {
          enable = true;
          settings.format = true;
        };
        lua_ls.enable = true;
        marksman.enable = true;
        nixd = {
          enable = true;
          settings = {
            diagnostic.suppress = ["sema-escaping-with"];
            formatting.command = [
              "alejandra"
              "-qq"
            ];
            nixpkgs.expr = "import <nixpkgs> {}";
            options = {
              nixos = {
                expr = ''(builtins.getFlake "$FLAKE").nixosConfigurations.gentian.options'';
              };
              home_manager = {
                expr = ''(builtins.getFlake "$FLAKE").homeConfigurations."oliver.breitwieser@mimir".options'';
              };
            };
          };
        };
        nushell.enable = false;
        protols.enable = true;
      };
    };
  };
}
