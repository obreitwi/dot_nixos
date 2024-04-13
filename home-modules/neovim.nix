{
  lib,
  config,
  pkgs,
  dot-desktop,
  dot-vim,
  hostname,
  ...
}: let
  treesitter_plugins = with pkgs.vimPlugins; [
    (
      nvim-treesitter.withPlugins (
        p: with p;
          nvim-treesitter.allGrammars
          ++ [
            (
              pkgs.tree-sitter.buildGrammar {
                language = "timesheet";
                version = dot-vim.rev;
                src = "${dot-vim}/utils/treesitter-timesheet";
                generate = true;
              }
            )
          tree-sitter-lua
          ] 
      )
    )
    nvim-treesitter-context
    nvim-treesitter-textobjects
    playground
    rainbow-delimiters-nvim
    pretty-fold-nvim
    nvim-autopairs
    tabout-nvim
    treesj

    # neorg
    neorg
    neorg-telescope
  ];
in {
  # NOTE: Currently treesitter parsers fail to load libstdc++6.so -> use LD_LIBRARY_PATH workaround from below
  programs.neovim = {
    enable = true;

    package = pkgs.neovim-unwrapped;

    plugins = treesitter_plugins;

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

  home.sessionVariables = lib.mkIf (!config.isNixOS) {
    # needed for treesitter grammar
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
}
