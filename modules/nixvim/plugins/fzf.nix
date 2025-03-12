{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "6c104d771e382f499025a35b10f39d997ce83b7d";
      sha256 = "04r9w3gim11ah9zbw5kvdvwzp5vbsblg0xkrqdkb4v9mkdbxpkxm";
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
