{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nixvim.lang.terraform = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all or config.my.nixvim.lang.terraform) {
    extraPlugins = [
      pkgs.vimPlugins.vim-terraform
    ];

    plugins.lsp.servers.terraformls.enable = true;
  };
}
