{
  lib,
  config,
  ...
}: {
  options.my.nixvim.lang.hyprland = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.hyprland) {
    plugins.lsp = {
      servers = {
        hyprls = {
          enable = true;
        };
      };
    };
  };
}
