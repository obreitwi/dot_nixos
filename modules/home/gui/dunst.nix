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
          }
          (
            lib.mkIf (!config.my.gui.stylix.enable)
            {
              font = "Envy Code R 8";
            }
          )
        ];
      };
    };
  };
}
