{
  config,
  lib,
  ...
}: {
  options.my.nixvim.lang.rust = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.rust) {
    plugins.rustaceanvim.enable = true;
  };
}
