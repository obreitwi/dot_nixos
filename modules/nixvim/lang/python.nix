{
  config,
  lib,
  ...
}: {
  options.my.nixvim.lang.python = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.python) {
    plugins.lsp.servers = {
      pyright.enable = true;
      pylsp = {
        settings.plugins.black.enable = true;
      };
    };
  };
}
