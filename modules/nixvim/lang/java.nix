{
  lib,
  pkgs,
  config,
  ...
}: {
  options.my.nixvim.lang.java = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.java) {
    lsp.servers = {
      jdtls.enable = true;
    };

    plugins.lsp.servers = {
      jdtls.enable = true;
    };

    plugins.jdtls.enable = true;
  };
}
