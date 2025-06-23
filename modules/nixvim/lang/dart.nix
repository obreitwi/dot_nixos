{
  config,
  lib,
  ...
}: {
  options.my.nixvim.lang.dart = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.dart) {
    plugins.lsp.servers = {
      dartls.enable = false;
    };
  };
}
