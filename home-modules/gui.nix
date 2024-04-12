{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.gui-apps.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.xmonad.enable {
    home.packages = with pkgs; [
      bluetuith
      discord
      neovide
    ];
  };
}
