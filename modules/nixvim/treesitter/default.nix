{
  pkgs,
  lib,
  ...
}: let
  nvim-treesitter = pkgs.vimPlugins.nvim-treesitter;

  timesheet-grammar = pkgs.tree-sitter.buildGrammar {
    language = "timesheet";
    version = "dev";
    src = ./grammars/timesheet;
    generate = true;
  };

  pl1-grammar = pkgs.tree-sitter.buildGrammar {
    language = "pli";
    version = "dev";
    src = ./grammars/pli;
    generate = true;
  };

  customGrammars = [
    timesheet-grammar
    pl1-grammar
  ];

  grammarPackages =
    nvim-treesitter.allGrammars
    ++ customGrammars;
in {
  imports = [./textobjects.nix];

  plugins = {
    nvim-autopairs.enable = true;
    rainbow-delimiters.enable = true;
    treesitter = {
      enable = true;
      inherit grammarPackages;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };

      package = nvim-treesitter;

      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;

      #luaConfig = {
      #content =
      ## lua
      #''
      #-- -- The following is a) not working and b) might not be needed since the integration for playground into treesitter.
      #-- require'nvim-treesitter.configs'.setup {
      #--   query_linter = {
      #--     enable = true,
      #--     use_virtual_text = true,
      #--     lint_events = {"BufWrite", "CursorHold"},
      #--   },
      #-- }
      #require'pretty-fold'.setup {}
      #'';
      #};

      languageRegister.timesheet = "timesheet";
      languageRegister.pli = "pli";
    };

    treesitter-context.enable = true;
    treesitter-textobjects = {
      enable = true;
    };

    treesj.enable = true;
    treesj.settings = {
      max_join_length = 360;
      use_default_keymaps = false;
    };
  };

  keymaps = [
    {
      key = "<leader>tss";
      mode = "n";
      action = ":lua vim.treesitter.start()<cr>";
    }
    {
      key = "<leader>tst";
      mode = "n";
      action = ":lua vim.treesitter.stop()<cr>";
    }
  ];

  extraConfigVim = ''
    " treesj mappings
    nnoremap <leader>sj :TSJJoin<CR>
    nnoremap <leader>ss :TSJSplit<CR>
    nnoremap <leader>st :TSJToggle<CR>
  '';

  extraConfigLua = ''
    require'pretty-fold'.setup {}
  '';

  #extraConfigLua = ''
  #vim.api.nvim_create_autocmd('FileType', {
  #group = vim.api.nvim_create_augroup('treesitter.setup', {}),
  #callback = function(args)
  #local buf = args.buf
  #local filetype = args.match

  #-- you need some mechanism to avoid running on buffers that do not
  #-- correspond to a language (like oil.nvim buffers), this implementation
  #-- checks if a parser exists for the current language
  #local language = vim.treesitter.language.get_lang(filetype) or filetype
  #if not vim.treesitter.language.add(language) then
  #return
  #end

  #-- replicate `fold = { enable = true }`
  #vim.wo.foldmethod = 'expr'
  #vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

  #-- replicate `highlight = { enable = true }`
  #vim.treesitter.start(buf, language)

  #-- replicate `indent = { enable = true }`
  #vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

  #-- `incremental_selection = { enable = true }` cannot be easily replicated
  #end,
  #})
  #'';

  extraPlugins = with pkgs.vimPlugins;
    [
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
    ]
    ++ customGrammars;
  # manually add all treesitter parsers
  #++ (lib.attrsets.attrValues (lib.attrsets.filterAttrs (k: v: lib.isDerivation v) pkgs.vimPlugins.nvim-treesitter-parsers));

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
