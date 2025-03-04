{pkgs, ...}: let
  diffconflicts = pkgs.vimUtils.buildVimPlugin {
    name = "diffconflicts";
    src = pkgs.fetchFromGitHub {
      owner = "whiteinge";
      repo = "diffconflicts";
      rev = "4972d1401e008c5e9afeb703eddd1b2c2a1d1199";
      hash = "sha256-JrJOm7dxTO7s8AKIlxFzYFOpoK7vCSgQwKpV3XnKDIM=";
    };
  };
  gv = pkgs.vimUtils.buildVimPlugin {
    name = "gv";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "gv.vim";
      rev = "b6bb6664e2c95aa584059f195eb3a9f3cb133994";
      hash = "sha256-Tb2IQR/l7TvokgpMWZBumyHULOvXQ2aGTL4P8fIEmRs=";
    };
  };

  gh-line = pkgs.vimUtils.buildVimPlugin {
    name = "gh-line";
    src = pkgs.fetchFromGitHub {
      owner = "obreitwi";
      repo = "vim-gh-line";
      rev = "c59fabeba7ec22f41e5225a309517412fa914b40";
      hash = "sha256-m+N6RkTfyn99HZGMhK8Q3T09VsWjqC6MbFvBXn+9akI=";
    };
  };
in {
  extraPlugins = [
    diffconflicts
    gh-line
    gv
    pkgs.vimPlugins.vim-git
  ];
  plugins.gitgutter.enable = true;
  plugins.fugitive.enable = true;

  globals.gh_open_command = "fn() { echo -n \"$@\" | xclip -selection copy; }; fn ";

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
}
