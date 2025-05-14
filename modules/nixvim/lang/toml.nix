{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nixvim.lang.toml = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all or config.my.nixvim.lang.toml) {
    extraPlugins = [
      pkgs.vimPlugins.vim-toml
    ];
  };
}
