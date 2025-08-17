{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "de1824f71d82896331a12cea4fe5781de5f8a315";
      sha256 = "16jrb6bkd2i3kbhip43ka27b89aaq2j3riax8w4ig6ngh023cm9n";
    };
  };
  fzf_vim = pkgs.vimUtils.buildVimPlugin {
    name = "fzf.vim";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf.vim";
      rev = "3725f364ccd25b85a91970720ba9bc2931861910";
      sha256 = "1gnsaf0yrvxvsdb08hjvgl1g5mpx07fcvyjizq0f688hw8613lay";
    };
  };
in {
  extraPlugins = [
    fzf
    fzf_vim
  ];
}
