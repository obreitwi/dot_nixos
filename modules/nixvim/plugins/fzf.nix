{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "9c1a47acf7453f9dad5905b7f23ad06e5195d51f";
      sha256 = "0xx946sgcbhfbq1zv2pk6d9qs5mxqqw0pgp6igv0fzib281w7x9a";
    };
  };
  fzf_vim = pkgs.vimUtils.buildVimPlugin {
    name = "fzf.vim";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf.vim";
      rev = "3cb44a8ba588e1ada409af495bdc6a4d2d37d5da";
      sha256 = "0v1svsw4wj4i2rayvksdpz8q65yvkdq9igpa64qq7xyd07jh6g8n";
    };
  };
in {
  extraPlugins = [
    fzf
    fzf_vim
  ];
}
