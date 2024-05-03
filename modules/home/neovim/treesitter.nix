{
  lib,
  config,
  pkgs,
  dot-vim,
  ...
}: let
  treesitter_plugins = with pkgs.vimPlugins; [
    (
      nvim-treesitter.withPlugins (
        p:
          with p;
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
            ]
            ++ lib.optionals (config.my.neovim.neorg) [
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
  ];
in {
  # NOTE: Currently treesitter parsers fail to load libstdc++6.so -> use LD_LIBRARY_PATH workaround from below
  programs.neovim.plugins = treesitter_plugins;
  home.sessionVariables = lib.mkIf (!config.isNixOS) {
    # needed for treesitter grammar
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
}
