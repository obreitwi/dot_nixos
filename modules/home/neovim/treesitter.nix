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
    (pretty-fold-nvim.overrideAttrs (final: prev: {
      src = pkgs.fetchFromGitHub {
        owner = "bbjornstad";
        repo = "pretty-fold.nvim";
        rev = "ce302faec7da79ea8afb5a6eec5096b68ba28cb5";
        hash = "sha256-KeRc1Jc6CSW8qeyiJZhbGelxewviL/jPFDxRW1HsfAk=";
      };
    }))
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
