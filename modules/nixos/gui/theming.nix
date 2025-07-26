{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf (config.my.gui.enable) {
  environment = {
    systemPackages = [pkgs.adwaita-icon-theme-legacy];
    variables.GTK_THEME = "Adwaita:dark";
  };
}
