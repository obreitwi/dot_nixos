{
  lib,
  config,
  ...
}: {
  options.my.nixvim.lang.typst = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.typst) {
    plugins.lsp.servers = {
      tinymist.enable = true;
    };

    plugins.typst-vim.enable = true;
  };
}
