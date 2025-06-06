{
  lib,
  config,
  pkgs,
  ...
}: {
  options.my.neovim = {
    neorg = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.my.neovim.neorg {
    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        # build issue with pathlib.nvim (probably gcc14)
        neorg
        neorg-telescope
      ];
    };
  };
}
