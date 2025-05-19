{
  config,
  lib,
  pkgs,
  pkgs-stable,
  ...
}: let
  wrepson = pkgs.callPackage (import ../../packages/wrepson) {inherit pkgs-stable;};
in {
  options.my.wrepson.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.wrepson.enable) {
    home.packages = [
      pkgs-stable.epsonscan2
      wrepson
    ];
  };
}
