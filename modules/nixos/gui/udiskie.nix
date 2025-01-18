{
  lib,
  config,
  ...
}: let
  inherit (config) my;
in {
  options.my.udiskie = {
    enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };
  config = lib.mkIf (my.gui.enable && my.udiskie.enable) {
    services.udisks2.enable = true;
  };
}
