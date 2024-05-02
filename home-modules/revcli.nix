{
  lib,
  config,
  pkgs,
  ...
}: {
  options.my.revcli.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.revcli.enable {
    home.packages = with pkgs; [
      revcli
    ];
  };
}
