{
  lib,
  config,
  ...
}: {
  options.my.nixvim.lang = {
    angular = {
      enable = lib.mkOption {
        default = true;
        type = lib.types.bool;
      };
      disable = lib.mkOption {
        default = true;
        type = lib.types.bool;
      };
    };
    typescript = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.typescript) {
      plugins.lsp.servers = {
        eslint = {
          enable = true;
          settings.format = true;
        };

        ts_ls = {
          enable = true;
          settings.format = false;
        };
      };
    })

    (lib.mkIf ((config.my.nixvim.lang.all || config.my.nixvim.lang.angular.enable) && !config.my.nixvim.lang.angular.disable) {
      lsp.servers.angularls.enable = true;

      plugins.lsp.servers = {
        angularls = {
          enable = true;
        };
      };
    })
  ];
}
