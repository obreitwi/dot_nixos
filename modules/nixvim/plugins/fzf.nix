{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "4efcc344c35e8bb7e6ba7bb23e5885051420b361";
      sha256 = "0pc1hfrclwzb1sll5vgqyq10n8c94vlxya8g31fa962zibx72q1v";
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
