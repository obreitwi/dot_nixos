{
  lib,
  config,
  ...
}: {
  programs.bat = {
    enable = true;
    config = lib.mkMerge [
      {
        pager = "less -RF";
      }

      (
        lib.mkIf (!config.my.gui.stylix.enable)
        {
          theme = "gruvbox-dark";
        }
      )
    ];
  };
}
