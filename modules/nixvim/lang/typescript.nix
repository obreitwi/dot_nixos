{
  lib,
  config,
  ...
}: {
  options.my.nixvim.lang.typescript = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.typescript) {
    plugins.lsp.servers = {
      eslint = {
        enable = true;
        settings.format = true;
      };

      ts_ls = {
        enable = true;
        settings.format = false;
      };
    };
  };
}
