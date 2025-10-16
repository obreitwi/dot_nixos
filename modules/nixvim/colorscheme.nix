{lib, ...}: let
  inherit (lib.nixvim) emptyTable;
in {
  colorscheme = "gruvbox";

  colorschemes.gruvbox = {
    enable = true;
    settings = {
      terminal_colors = true; # add neovim terminal colors
      undercurl = true;
      underline = true;
      bold = true;
      italic = {
        strings = false;
        emphasis = true;
        comments = true;
        operators = false;
        folds = true;
      };
      strikethrough = true;
      invert_selection = false;
      invert_signs = false;
      invert_tabline = false;
      invert_intend_guides = false;
      inverse = true; # invert background for search; diffs; statuslines and errors
      contrast = "hard"; # can be "hard"; "soft" or empty string
      palette_overrides = emptyTable;
      overrides = emptyTable;
      dim_inactive = false;
      transparent_mode = false;
    };
  };

  colorschemes.github-theme.enable = true;
}
