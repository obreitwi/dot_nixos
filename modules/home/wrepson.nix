{
  config,
  lib,
  pkgs,
  ...
}: let
  wrepson = pkgs.callPackage (import ../../packages/wrepson) {};
in {
  options.my.wrepson.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.wrepson.enable {
    home.packages = [wrepson];
  };
}
