{
  config,
  lib,
  ...
}: {
  options.my.nixvim.lang.postgres = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.postgres) {
    plugins.lsp.servers = {
      postgres_lsp.enable = true;
    };
  };
}
