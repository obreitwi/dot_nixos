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

      ruff.enable = true;
      #pylsp = {
      #enable = true;
      ##settings.plugins.black.enable = true;
      ##settings.plugins.black.preview = true;
      ##settings.plugins.black.line_length = 120;

      #settings.plugins.ruff.enable = true;
      #};
    };
  };
}
