{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gui.keepass.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.keepass.enable) {
    home.packages = with pkgs; [
      keepassxc
    ];
  };
}
