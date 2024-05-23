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

  config = lib.mkIf config.my.gui-apps.enable {
    home.packages = with pkgs; [
      autorandr
      bluetuith
      discord
      keepassxc
      neovide
      nextcloud-client
      spotify
      xterm
    ];
  };
}
