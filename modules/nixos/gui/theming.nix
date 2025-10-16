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

  config = lib.mkMerge [
    {
      # Always enable stylix on nixos level
      stylix = {
        enable = true;
        autoEnable = config.my.gui.stylix.enable;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
      };
    }

    (
      lib.mkIf config.my.gui.stylix.enable {
        stylix = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
          polarity = "dark";
          autoEnable = true;

          targets = {
            gnome.enable = true; # even if not installed
            dunst.enable = false;
          };
        };
      }
    )
  ];
}
