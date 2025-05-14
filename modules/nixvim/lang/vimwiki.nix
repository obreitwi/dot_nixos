{
  config,
  lib,
  utils,
  ...
}: let
  inherit (utils) autoCmdFT;
in {
  options.my.nixvim.lang.vimwiki = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all or config.my.nixvim.lang.vimwiki) {
    autoCmd = [
      (autoCmdFT {
        lang = "vimwiki";
        command =
          # vim
          "setlocal tabstop=2 | setlocal shiftwidth=2 | setlocal expandtab | setlocal foldlevel=0 | setlocal comments=fb:*,fb:# | setlocal foldminlines=0";
      })
    ];
  };
}
