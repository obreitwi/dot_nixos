{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.my.gui.enable) {
    programs.rofi.enable = true;
    programs.rofi.theme = "gruvbox-dark";
  };
}
