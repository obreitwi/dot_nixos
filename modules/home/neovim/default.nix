{
  config,
  pkgs,
  myUtils,
  ...
}: {
  imports = [
    ./neorg.nix
    ./neogit.nix
    ./octo.nix
    ./prefix.nix
    ./treesitter.nix
  ];

  home.packages = with pkgs; [
    ctags # needed for tagbar
  ];

  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      {
        plugin = oil-nvim;
        config =
          myUtils.vimLua
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
      {
        plugin = telescope-fzf-native-nvim;
      }
      {
        plugin = mini-nvim;
        config =
          myUtils.vimLua
          /*
          lua
          */
          ''
            require("mini.ai").setup()
          '';
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

  home.sessionVariables = {
    EDITOR = "${config.programs.neovim.package}/bin/nvim";
  };
}
