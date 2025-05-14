{
  lib,
  config,
  pkgs,
  ...
}: {
  options.my.nixvim.lang.haskell = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all or config.my.nixvim.lang.haskell) {
    extraPlugins = [
      pkgs.vimPlugins.haskell-tools-nvim
    ];

    extraConfigLua =
      # lua
      ''
        require('haskell-tools')
      '';
  };
}
