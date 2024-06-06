{
  pkgs,
  myUtils,
  ...
}: {
  imports = [
    ./neorg.nix
    ./treesitter.nix
  ];

  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
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
      {
        plugin = telescope-file-browser-nvim;
      }
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
}
