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
    ./zathura.nix
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
      # neovide # deactivated until build is fixed upstream
      spotify
      udiskie

      pkgs.stable.gpick # pick color values from screen (build issue, probably gcc14)

      # drag & drop from terminal
      blobdrop
      ripdrag

      xdotool
    ];
  };
}
