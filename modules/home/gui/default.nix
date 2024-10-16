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
    ./keynav.nix
    ./keepass.nix
    ./nextcloud.nix
    ./redshift.nix
    ./slock.nix
    ./theming.nix
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
      udiskie

      gpick # pick color values from screen

      # drag & drop from terminal
      blobdrop
      ripdrag

      xdotool
    ];
  };
}
