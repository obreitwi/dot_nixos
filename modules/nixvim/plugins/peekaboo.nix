{pkgs, ...}: let
  peekaboo = pkgs.vimUtils.buildVimPlugin {
    name = "peekaboo";
    src = pkgs.fetchFromGitHub {
      # fixes resize bug
      owner = "Gee19";
      repo = "vim-peekaboo";
      rev = "287ea250d66b6640595650c3e0ba9371ad81141c";
      hash = "sha256-1dhAzrKqHhCLSapHkBXoMa+jpgS+ZHKwqklzJ8g8Pcc=";
    };
  };
in {
  extraPlugins = [peekaboo];
}
