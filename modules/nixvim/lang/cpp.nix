{
  config,
  lib,
  utils,
  ...
}: let
  inherit (utils) autoCmdFT;
in {
  options.my.nixvim.lang.cpp = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.cpp) {
    autoCmd = [
      (autoCmdFT {
        lang = "cpp";
        command = "setlocal cinoptions=g0,hs,N-s,+0";
      })
    ];

    plugins.clangd-extensions.enable = true;
    plugins.lsp.servers.clangd.enable = true;
    plugins.lsp.servers.mesonlsp.enable = true;
  };
}
