{pkgs, ...}: let
  peekaboo = pkgs.vimUtils.buildVimPlugin {
    name = "peekaboo";
    src = pkgs.fetchFromGitHub {
      # fixes resize bug
      owner = "Gee19";
      repo = "vim-peekaboo";
      rev = "287ea250d66b6640595650c3e0ba9371ad81141c";
      sha256 = "1irx7k42fws9maq74r5y0jka7brix0ar0ixa965i07manb741n6m";
    };
  };
in {
  extraPlugins = [peekaboo];
}
