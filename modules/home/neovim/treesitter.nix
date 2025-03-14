{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs) dot-vim;
  treesitter-plugins = with pkgs.vimPlugins; [
    (nvim-treesitter.withPlugins (
      p:
        with p;
          nvim-treesitter.allGrammars
          ++ [
            (pkgs.tree-sitter.buildGrammar {
              language = "timesheet";
              version = dot-vim.rev;
              src = "${dot-vim}/utils/treesitter-timesheet";
              generate = true;
            })
          ]
          ++ lib.optionals (config.my.neovim.neorg) [
            tree-sitter-lua
          ]
    ))
    nvim-treesitter-context
    nvim-treesitter-textobjects
    playground
    rainbow-delimiters-nvim
    (pretty-fold-nvim.overrideAttrs (
      final: prev: {
        src = pkgs.fetchFromGitHub {
          owner = "bbjornstad";
          repo = "pretty-fold.nvim";
          rev = "1eb18f228972e86b7b8f5ef33ca8091e53fb1e49";
          sha256 = "1j2q5ks5rxcydr8q0hcb5zaxsr5z2vids84iihn8c6jgwadwzhfi";
        };
      }
    ))
    nvim-autopairs
    tabout-nvim
    treesj
    otter-nvim # currently not configured, see if useful
  ];
in {
  # NOTE: Currently treesitter parsers fail to load libstdc++6.so -> use LD_LIBRARY_PATH workaround from below
  programs.neovim.plugins = treesitter-plugins;
  home.sessionVariables = lib.mkIf (!config.my.isNixOS) {
    # needed for treesitter grammar
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };
}
