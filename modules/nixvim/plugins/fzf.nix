{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "549ce3cf6c622aad9a2d5ecde491681244327681";
      sha256 = "0cc9w4xyqlqr70xxf1rzv0cmaamczydl4ias5g2zd2lqmsrq1d0k";
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
