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
    ./keepass.nix
    ./nextcloud.nix
    ./redshift.nix
    ./theming.nix
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

      # slack # (does not work with home-manager because sandbox needs to be owned by root)

      # drag & drop from terminal
      blobdrop
      ripdrag
    ];
  };
}
