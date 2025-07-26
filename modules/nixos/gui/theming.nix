{
  lib,
  config,
  pkgs,
  ...
}: {
  options.my.gui.stylix.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.gui.enable (
    lib.mkMerge [
      (
        lib.mkIf (!config.my.gui.stylix.enable) {
          environment = lib.mkIf (!config.my.gui.stylix.enable) {
            systemPackages = [pkgs.adwaita-icon-theme-legacy];
            variables.GTK_THEME = "Adwaita:dark";
          };
        }
      )

      (lib.mkIf config.my.gui.stylix.enable {
        stylix = {
          enable = config.my.gui.stylix.enable;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
        };
      })
    ]
  );
}
