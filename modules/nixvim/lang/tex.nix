{
  config,
  lib,
  ...
}: {
  options = {
    my.nixvim.tex.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.my.nixvim.tex.enable {
    plugins.cmp.settings.sources = [{ name = "texlab"; }];
    plugins.lsp.servers.texlab.enable = true;

    plugins.vimtex = {
      enable = true;
      settings.view_mode = "zathura";
    };
  };
}
