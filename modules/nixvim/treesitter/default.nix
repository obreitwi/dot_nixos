{
  pkgs,
  lib,
  ...
}: let
in {
  plugins = {
    nvim-autopairs.enable = true;
    rainbow-delimiters.enable = true;
    treesitter = {
      enable = true;
      grammarPackages =
        pkgs.vimPlugins.nvim-treesitter.allGrammars
        ++ [
          (pkgs.tree-sitter.buildGrammar {
            language = "timesheet";
            version = "dev";
            src = ./grammars/timesheet;
            generate = true;
          })
        ];
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };

      folding = true;

      luaConfig = {
        content =
          # lua
          ''
            require'nvim-treesitter.configs'.setup {
              playground = { enable = true, },
              query_linter = {
                enable = true,
                use_virtual_text = true,
                lint_events = {"BufWrite", "CursorHold"},
              },
            }
            require'pretty-fold'.setup {}
          '';
      };
    };

    treesitter-context.enable = true;

    treesitter-textobjects = {
      enable = true;
      select = {
        enable = true;
        keymaps = {
          # You can use the capture groups defined in textobjects.scm
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          # you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
          "ic" = {
            query = "@class.inner";
            desc = "Select inner part of a class region";
          };
        };
        # You can choose the select mode (default is charwise 'v')
        selectionModes = {
          "@parameter.outer" = "v"; # charwise
          "@function.outer" = "V"; # linewise
          "@class.outer" = "<c-v>"; # blockwise
        };
        # If you set this to `true` (default is `false`) then any textobject is
        # extended to include preceding xor succeeding whitespace. Succeeding
        # whitespace has priority in order to act similarly to eg the built-in
        # `ap`.
        includeSurroundingWhitespace = true;
      };
      move = {
        enable = true;
        setJumps = true; # whether to set jumps in the jumplist
        gotoNextStart = {
          "]m" = "@function.outer";
          "]]" =
            # lua
            ''{ query = "@class.outer", desc = "Next class start" }'';
          #
          # You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
          "]o" = "@loop.*";
          # ["]o"] = { query = { "@loop.inner"; "@loop.outer" } }
          #
          # You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
          # Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
          "]s" =
            # lua
            ''
              {
                          query = "@local.scope";
                          query_group = "locals";
                          desc = "Next scope";
                        }'';
          "]z" =
            # lua
            ''
              {
                          query = "@fold",
                          query_group = "folds",
                          desc = "Next fold",
                        }'';
        };
        gotoNextEnd = {
          "]M" = "@function.outer";
          "][" = "@class.outer";
        };
        gotoPreviousStart = {
          "[m" = "@function.outer";
          "[[" = "@class.outer";
        };
        gotoPreviousEnd = {
          "[M" = "@function.outer";
          "[]" = "@class.outer";
        };
        # Below will go to either the start or the end; whichever is closer.
        # Use if you want more granular movements
        # Make it even more gradual by adding multiple queries and regex.
        gotoNext = {
          "]c" = "@conditional.outer";
        };
        gotoPrevious = {
          "[c" = "@conditional.outer";
        };
      };
    };
    treesj.enable = true;
    treesj.settings = {
      max_join_length = 360;
      use_default_keymaps = false;
    };
  };
  extraConfigVim = ''
    " treesj mappings
    nnoremap <leader>sj :TSJJoin<CR>
    nnoremap <leader>ss :TSJSplit<CR>
    nnoremap <leader>st :TSJToggle<CR>
  '';

  extraPlugins = with pkgs.vimPlugins; [
    playground
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
    # tabout-nvim
    # otter-nvim # currently not configured, see if useful
  ];

  opts.conceallevel = 2;

  extraFiles = let
    queriesDir = ./queries;
    queriesPrefix = toString queriesDir;
  in
    lib.pipe (lib.filesystem.listFilesRecursive queriesPrefix) [
      (map (
        file: let
          relative = lib.strings.removePrefix queriesPrefix file;
        in {
          name = "tsquery-${relative}";
          value = {
            target = "queries/${relative}";
            source = queriesDir + relative;
          };
        }
      ))
      builtins.listToAttrs
    ];
}
