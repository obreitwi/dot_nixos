{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "e15cba0c8c7c9dd3388d260cf5b5de7fc044dfbc";
      sha256 = "029jby37wjawz9qpl4wm7vqbqsrksl3d1za3qj68cgpwdcfxz8d6";
    };
  };
  fzf_vim = pkgs.vimUtils.buildVimPlugin {
    name = "fzf.vim";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf.vim";
      rev = "1fff637559f29d5edbdb05e03327954a8cd9e406";
      sha256 = "13xh17bqnb1k32jm53x9kqc8x6njwcdha9xbwn2zhm0s8dgqikzx";
    };
  };
in {
  extraPlugins = [
    fzf
    fzf_vim
  ];
}
