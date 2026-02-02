{
  plugins.treesitter-textobjects = {
    enable = true;
  };

  extraConfigLua = ''
    -- configuration
    require("nvim-treesitter-textobjects").setup {
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- You can choose the select mode (default is charwise 'v')
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * method: eg 'v' or 'o'
        -- and should return the mode ('v', 'V', or '<c-v>') or a table
        -- mapping query_strings to modes.
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        -- If you set this to `true` (default is `false`) then any textobject is
        -- extended to include preceding or succeeding whitespace. Succeeding
        -- whitespace has priority in order to act similarly to eg the built-in
        -- `ap`.
        --
        -- Can also be a function which gets passed a table with the keys
        -- * query_string: eg '@function.inner'
        -- * selection_mode: eg 'v'
        -- and should return true of false
        include_surrounding_whitespace = false,
      },
    }

    -- keymaps
    -- You can use the capture groups defined in `textobjects.scm`
    vim.keymap.set({ "x", "o" }, "am", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "im", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ac", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ic", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
    end)
    -- You can also use captures from other query groups like `locals.scm`
    vim.keymap.set({ "x", "o" }, "as", function()
      require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
    end)

    -- keymaps
    vim.keymap.set("n", "<leader>a", function()
      require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
    end)
    vim.keymap.set("n", "<leader>A", function()
      require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.outer"
    end)

    -- configuration
    require("nvim-treesitter-textobjects").setup {
      move = {
        -- whether to set jumps in the jumplist
        set_jumps = true,
      },
    }

    -- keymaps
    -- You can use the capture groups defined in `textobjects.scm`
    vim.keymap.set({ "n", "x", "o" }, "]m", function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]]", function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
    end)
    -- You can also pass a list to group multiple queries.
    vim.keymap.set({ "n", "x", "o" }, "]o", function()
      require("nvim-treesitter-textobjects.move").goto_next_start({"@loop.inner", "@loop.outer"}, "textobjects")
    end)
    -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
    vim.keymap.set({ "n", "x", "o" }, "]s", function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@local.scope", "locals")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]z", function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@fold", "folds")
    end)

    vim.keymap.set({ "n", "x", "o" }, "]M", function()
      require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "][", function()
      require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "x", "o" }, "[m", function()
      require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[[", function()
      require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "x", "o" }, "[M", function()
      require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[]", function()
      require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
    end)

    -- Go to either the start or the end, whichever is closer.
    -- Use if you want more granular movements
    vim.keymap.set({ "n", "x", "o" }, "]d", function()
      require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[d", function()
      require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
    end)

    local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

    -- Repeat movement with ; and ,
    -- ensure ; goes forward and , goes backward regardless of the last direction
    vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    -- vim way: ; goes to the direction you were moving.
    -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
    vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
  '';

  # Deprectated config
  #treesitter-textobjects = {
  #enable = true;
  #settings = {
  #select = {
  #enable = true;
  #keymaps = {
  ## You can use the capture groups defined in textobjects.scm
  #"af" = "@function.outer";
  #"if" = "@function.inner";
  #"ac" = "@class.outer";
  ## you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
  #"ic" = {
  #query = "@class.inner";
  #desc = "Select inner part of a class region";
  #};
  #};
  ## You can choose the select mode (default is charwise 'v')
  #selection_modes = {
  #"@parameter.outer" = "v"; # charwise
  #"@function.outer" = "V"; # linewise
  #"@class.outer" = "<c-v>"; # blockwise
  #};
  ## If you set this to `true` (default is `false`) then any textobject is
  ## extended to include preceding xor succeeding whitespace. Succeeding
  ## whitespace has priority in order to act similarly to eg the built-in
  ## `ap`.
  #include_surrounding_whitespace = true;
  #};
  #move = {
  #enable = true;
  #set_jumps = true; # whether to set jumps in the jumplist
  #goto_next_start = {
  #"]m" = "@function.outer";
  #"]]" =
  ## lua
  #''{ query = "@class.outer", desc = "Next class start" }'';
  ##
  ## You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
  #"]o" = "@loop.*";
  ## ["]o"] = { query = { "@loop.inner"; "@loop.outer" } }
  ##
  ## You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
  ## Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
  #"]s" =
  ## lua
  #''
  #{
  #query = "@local.scope";
  #query_group = "locals";
  #desc = "Next scope";
  #}
  #'';
  #"]z" =
  ## lua
  #''
  #{
  #query = "@fold",
  #query_group = "folds",
  #desc = "Next fold",
  #}
  #'';
  #};
  #goto_next_end = {
  #"]M" = "@function.outer";
  #"][" = "@class.outer";
  #};
  #goto_previous_start = {
  #"[m" = "@function.outer";
  #"[[" = "@class.outer";
  #};
  #goto_previous_end = {
  #"[M" = "@function.outer";
  #"[]" = "@class.outer";
  #};
  ## Below will go to either the start or the end; whichever is closer.
  ## Use if you want more granular movements
  ## Make it even more gradual by adding multiple queries and regex.
  #goto_next = {
  #"]c" = "@conditional.outer";
  #};
  #goto_previous = {
  #"[c" = "@conditional.outer";
  #};
  #};
  #};
  #};
}
