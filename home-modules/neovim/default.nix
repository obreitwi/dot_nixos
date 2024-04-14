{
  lib,
  config,
  pkgs,
  dot-desktop,
  hostname,
  myUtils,
  ...
}:{
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
          {
            plugin = oil-nvim;
            config =
              myUtils.toLua
              /*
              lua
              */
              ''
                require"oil".setup{}
                vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
              '';
          }
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
