{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "93cb3758b5f08a6dbf30c6e3d2e1de9b0be52a63";
      sha256 = "0bsn3pqw0bg6qsr42x31w6ras44vxhshzcg8sk4hvclqcwdxb9rw";
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
