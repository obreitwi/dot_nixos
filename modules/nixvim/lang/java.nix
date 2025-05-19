{
  lib,
  config,
  ...
}: {
  options.my.nixvim.lang.java = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all or config.my.nixvim.lang.java) {
    plugins.lsp.servers = {
      jdtls.enable = true;
    };

    plugins.jdtls.enable = true;
  };
}
