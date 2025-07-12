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
        lua_ls.enable = true;
        marksman.enable = true;
        nushell.enable = false;
        protols.enable = true;
      };
    };
  };
}
