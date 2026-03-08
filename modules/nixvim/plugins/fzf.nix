{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "f3ca0b136540c2e042462b31ed91e2f89b906658";
      sha256 = "01kgbl47rbzbldjr62prwqwlvv9r2jf0nylms10h851xcp7fpzvq";
    };
  };
  fzf_vim = pkgs.vimUtils.buildVimPlugin {
    name = "fzf.vim";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf.vim";
      rev = "34a564c81f36047f50e593c1656f4580ff75ccca";
      sha256 = "1ikiizmida4r6yylrbjy6kc3i0if5jm31cpaa9mgy38yk5gwyj4z";
    };
  };
in {
  extraPlugins = [
    fzf
    fzf_vim
  ];
}
