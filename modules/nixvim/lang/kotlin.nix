{
  lib,
  pkgs,
  config,
  utils,
  ...
}: let
  inherit (utils) autoCmdsFT;
in {
  options.my.nixvim.lang.kotlin = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.kotlin) {
    lsp.servers = {
      kotlin_language_server.enable = false;
    };

    plugins.lsp-format = {
      settings = {
        kotlin = {
          exclude = ["kotlin_language_server"];
        };
      };
    };

    plugins.lsp.servers = {
      kotlin_language_server = {
        enable = false;
      };
    };

    autoCmd = autoCmdsFT {lang = "kotlin";} [
      "nmap <buffer> <leader>cff :!gradle detekt --auto-correct<CR>"
    ];

    extraConfigLua =
      /*
      lua
      */
      ''
        vim.lsp.config('kotlin_lsp', {
        cmd = { "${pkgs.kotlin-lsp}/bin/kotlin-lsp", "--stdio"}
        })
        -- temporarily enable kotlin_lsp until nixvim has support for kotlin_lsp out of the box
        vim.lsp.enable('kotlin_lsp')
      '';
  };
}
