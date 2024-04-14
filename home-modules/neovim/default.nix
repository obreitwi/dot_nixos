{
  lib,
  config,
  pkgs,
  dot-desktop,
  hostname,
  ...
}:
{
  imports = [./treesitter.nix];

  options.my.neovim = {
    neorg = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = {
    programs.neovim = {
      enable = true;

      plugins = with pkgs.vimPlugins;
        [
          oil-nvim
        ]
        ++ lib.optionals (config.my.neovim.neorg) [
          # neorg
          neorg
          neorg-telescope
        ];

      viAlias = true;
      vimAlias = true;

      extraConfig =
        /*
        vim
        */
        ''
          set runtimepath^=~/.vim runtimepath+=~/.vim/after
          let &packpath = &runtimepath
          let g:nix_enabled = 1
          source ~/.vimrc
        '';
    };
  };
}
