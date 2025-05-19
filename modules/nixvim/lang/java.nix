{
  lib,
  config,
  ...
}: {
  options.my.nixvim.lang.java = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.java) {
    plugins.lsp.servers = {
      jdtls.enable = true;
      kotlin_language_server.enable = true;
    };

    plugins.jdtls.enable = true;
  };
}
