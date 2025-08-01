{
  lib,
  pkgs,
  config,
  ...
}: {
  options.my.nixvim.lang.kotlin = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.kotlin) {
    lsp.servers = {
      kotlin_language_server.enable = true;
    };

    plugins.lsp.servers = {
      kotlin_language_server.enable = true;
    };

    extraConfigLua =
      /*
      lua
      */
      ''
        vim.lsp.config('kotlin_lsp', {
        cmd = { "${pkgs.kotlin-lsp}/bin/kotlin-lsp", "--stdio"}
        })
        -- temporarily enable kotlin_lsp until nixvim used native api/has support for kotlin_lsp
        -- vim.lsp.enable('kotlin_lsp')
      '';
  };
}
