{ ... }:
{
  programs.readline = {
    enable = true;

    variables = {
      show-all-if-ambiguous = true;
      visible-stats = true;
      editing-mode = "vi";
      keymap = "vi";
    };
  };
}
