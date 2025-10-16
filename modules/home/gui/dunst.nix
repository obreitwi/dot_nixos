{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.dunst.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.dunst.enable) {
    home.packages = with pkgs; [
      dunst
      ttf-envy-code-r
    ];

    services.dunst = {
      enable = true;
      settings = {
        global = lib.mkMerge [
          {
            monitor = 0;
            history = "meta+tab";
          }
          (
            lib.mkIf (!config.my.gui.stylix.enable)
            {
              font = "Envy Code R 8";
              frame_color = "#458588";
              frame_width = 2;
              gap_size = 1;
              separator_color = "frame";
              corner_radius = 5;
              #font = Inter Variable 11;
              enable_recursive_icon_lookup = true;
              icon_theme = "Papirus-Dark, Adwaita";
              max_icon_size = 64;
              transparency = 10;
            }
          )
        ];

        urgency_low =
          lib.mkIf (!config.my.gui.stylix.enable)
          {
            background = "#282828";
            foreground = "#ebdbb2";
          };

        urgency_normal =
          lib.mkIf (!config.my.gui.stylix.enable)
          {
            background = "#282828";
            foreground = "#ebdbb2";
          };

        urgency_critical =
          lib.mkIf (!config.my.gui.stylix.enable)
          {
            background = "#282828";
            foreground = "#ebdbb2";
            frame_color = "#cc241d";
          };
      };
    };
  };
}
