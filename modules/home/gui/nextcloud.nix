{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gui.nextcloud.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.nextcloud.enable && config.my.gui.enable) {
    home.packages = with pkgs; [
      nextcloud-client
    ];
  };
}
