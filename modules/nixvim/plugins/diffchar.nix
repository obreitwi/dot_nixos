{pkgs, ...}: let
  diffchar = pkgs.vimUtils.buildVimPlugin {
    name = "diffchar";
    src = pkgs.fetchFromGitHub {
      owner = "rickhowe";
      repo = "diffchar.vim";
      rev = "ccf4c238a71d834ad1e21834f08be274bc0f05a3";
      sha256 = "1ca2nzrmr5dix5jf8aispn4aixzdky760ngig69w8yw7zv2knh1c";
    };
  };
in {
  extraPlugins = [diffchar];
}
