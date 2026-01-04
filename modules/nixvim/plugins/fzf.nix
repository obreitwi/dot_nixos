{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "3c7cbc9d476025e0cf90e2303bce38935898df1f";
      sha256 = "0hflsl0fz4a4d7i9qnmsljf08710djllpr92lhqgzh3idlyjch6b";
    };
  };
  fzf_vim = pkgs.vimUtils.buildVimPlugin {
    name = "fzf.vim";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf.vim";
      rev = "ddc14a6a5471147e2a38e6b32a7268282f669b0a";
      sha256 = "07n3g0gggpi3mpfikflr5vsmc63bkrzcv296xinhap3pivcryn4s";
    };
  };
in {
  extraPlugins = [
    fzf
    fzf_vim
  ];
}
