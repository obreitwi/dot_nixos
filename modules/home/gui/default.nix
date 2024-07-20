{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./autorandr.nix
    ./dunst.nix
    ./firefox.nix
    ./fonts.nix
    ./iwd.nix
    ./redshift.nix
    ./x11base.nix
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
      neovide
      spotify

      # TODO not really needed on mimir
      keepassxc
      nextcloud-client

      # drag & drop from terminal
      blobdrop
      ripdrag
    ];
  };
}
