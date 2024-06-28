{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./autorandr.nix
    ./redshift.nix
  ];

  options.my.gui.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.gui.enable {
    home.packages = with pkgs; [
      backlight
      bluetuith
      discord
      flameshot # take screenshots and edit them
      keepassxc
      neovide
      nextcloud-client
      spotify
      xdg-utils
      xterm

      # drag & drop from terminal
      blobdrop
      ripdrag

      # backup terminal if nixGL is out of date with GPU drivers
      st
    ];
  };
}
