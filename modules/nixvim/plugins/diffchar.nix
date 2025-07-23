{pkgs, ...}: let
  diffchar = pkgs.vimUtils.buildVimPlugin {
    name = "diffchar";
    src = pkgs.fetchFromGitHub {
      owner = "rickhowe";
      repo = "diffchar.vim";
      rev = "9eca051f72fe8b163651bdca09ebe57a3e2eed68";
      sha256 = "0y5rp5g24hkfq5xsjgm0sy5crvw917lnlp230p186l1bx4a6bn1w";
    };
  };
in {
  extraPlugins = [diffchar];
}
