{pkgs, ...}: let
  diffchar = pkgs.vimUtils.buildVimPlugin {
    name = "diffchar";
    src = pkgs.fetchFromGitHub {
      owner = "rickhowe";
      repo = "diffchar.vim";
      rev = "ccf4c238a71d834ad1e21834f08be274bc0f05a3";
      sha256 = "sha256-LEA7xf6He8STefFZYI6f7feoiL06KuRk6bGVXPO3QrE=";
    };
  };
in {
  extraPlugins = [diffchar];
}
