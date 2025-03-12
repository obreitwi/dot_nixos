{pkgs, ...}: let
  fzf = pkgs.vimUtils.buildVimPlugin {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf";
      rev = "26bcd0c90d4c77938d2011f994d943e531322504";
      sha256 = "sha256-YyUNnLynkhdMAV5MBh2H8pfVB5CJMT6iv5GZ1M2QAFQ=";
    };
  };
  fzf_vim = pkgs.vimUtils.buildVimPlugin {
    name = "fzf.vim";
    src = pkgs.fetchFromGitHub {
      owner = "junegunn";
      repo = "fzf.vim";
      rev = "245eaf8e50fe440729056ce8d4e7e2bb5b1ff9c9";
      sha256 = "sha256-i2QaGX5AlHxSvJ9wxxYhKBc8YsnKFDi+5ahHOAlJ3io=";
    };
  };
in {
  extraPlugins = [
    fzf
    fzf_vim
  ];
}
