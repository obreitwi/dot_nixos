{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "ba6d1b8772ce5e75ff999dcca21c0fadb689d7bf";
      sha256 = "0wrbqzp5vcy5szjnkhz5h22g8gj58pnzyyfradqg4z5kfafzq9q3";
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
