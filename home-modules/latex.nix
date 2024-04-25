{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.latex.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.latex.enable {
    home.packages = with pkgs; [
      texlab
      texliveFull
    ];
  };
}
