{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gui.nixGL.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.gui.enable {
    home.packages = with pkgs; [
      nixgl.auto
    ];
  };
}
