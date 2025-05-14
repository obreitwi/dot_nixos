{
  config,
  lib,
  ...
}: {
  options.my.nixvim.lsp = {
    all = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.my.nixvim.lsp.all {
    plugins.lsp = {
      servers = {
        ast_grep.enable = true;
        bashls.enable = true;
        cssls = {
          enable = false;
          settings.scss.validate = false;
          onAttach.function = "client.server_capabilities.documentFormattingProvider = false";
        };
        dartls.enable = false;
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
        postgres_lsp.enable = true;
        protols.enable = true;
        pyright.enable = true;
        pylsp = {
          settings.plugins.black.enable = true;
        };
        stylelint_lsp = {
          enable = true;
          settings = {
            autoFixOnFormat = true;
          };
        };
        ts_ls = {
          enable = true;
          settings.format = false;
        };
        tailwindcss.enable = false;
      };
    };
  };
}
