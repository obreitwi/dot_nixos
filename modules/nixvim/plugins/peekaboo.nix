{pkgs, ...}: let
  peekaboo = pkgs.vimUtils.buildVimPlugin {
    name = "peekaboo";
    src = pkgs.fetchFromGitHub {
      # fixes resize bug
      owner = "gibfahn";
      repo = "vim-peekaboo";
      rev = "3490bc6d2848606e59983ad9582883d4706a386f"; # branch no_winrestcmd
      sha256 = "sha256-qZMVX00korDLnbSTr+S0JgEpsk32J2IvKSALWQgb+0Y=";
    };
  };
in {
  extraPlugins = [peekaboo];
}
