{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./autorandr.nix
    ./chrome.nix
    ./dunst.nix
    ./firefox.nix
    ./fonts.nix
    ./hyprland.nix
    ./iwd.nix
    ./keepass.nix
    ./keynav.nix
    ./nextcloud.nix
    ./redshift.nix
    ./rofi.nix
    ./slock.nix
    ./theming.nix
    ./zathura.nix
  ];

  options.my.gui.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.gui.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
        };
      };
    };

    home.packages = with pkgs; [
      backlight
      bluetuith
      discord
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
