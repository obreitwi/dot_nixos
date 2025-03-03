{pkgs, ...}: {
  extraPlugins = [
    pkgs.vimPlugins.vim-git
  ];
  plugins.gitgutter.enable = true;
  plugins.fugitive.enable = true;

  # " Clean git objects when buffer is left
  # autocmd vimrc BufReadPost fugitive://* set bufhidden=delete
  keymaps = [
    # fugitive
    {
      mode = "n";
      key = "<leader>F";
      action = "<CMD>Git<CR><CMD>on<CR>";
    }
    {
      mode = "n";
      key = "<leader>fa";
      action = "<CMD>Git add %<CR>";
    }
    {
      mode = "n";
      key = "<leader>fc";
      action = "q:iGit commit -m \"\"<Left>";
    }
    {
      mode = "n";
      key = "gb";
      action = "<CMD>Git blame<CR>";
    }
    {
      mode = "n";
      key = "gB";
      action = "<CMD>Git blame -CCCw<CR>";
    }
  ];

  # TODO: diffconflicts
  # TODO: gv.vim
  # TODO: vim-gh-line (my fork)
}
