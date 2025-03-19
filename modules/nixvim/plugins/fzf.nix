{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "923c3a814de39ff906d675834af634252b3d2b3f";
      sha256 = "12xfznnq38glyxp1ah356v1ywcqrbfbjjvrnr82jxzxw4vw2xpmk";
    };
  };
  fzf_vim = pkgs.vimUtils.buildVimPlugin {
    name = "fzf.vim";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf.vim";
      rev = "245eaf8e50fe440729056ce8d4e7e2bb5b1ff9c9";
      sha256 = "0any944khix8wnz3h56ar5i3q5r844bcfw4zpi97r520gqcilr4b";
    };
  };
in {
  extraPlugins = [
    fzf
    fzf_vim
  ];
}
