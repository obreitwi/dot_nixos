{
  lib,
  config,
  ...
}: {
  options.my.gui.hyprland.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.gui.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];
  };
}
