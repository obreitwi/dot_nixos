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
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.wrepson.enable {
    home.packages = [
      pkgs-stable.epsonscan2
      wrepson
    ];
  };
}
