{pkgs, ...}: let
  diffchar = pkgs.vimUtils.buildVimPlugin {
    name = "diffchar";
    src = pkgs.fetchFromGitHub {
      owner = "rickhowe";
      repo = "diffchar.vim";
      rev = "044bab9f01c0edb8633c2c60fe0dfee07b28963b";
      sha256 = "1vm9nj7zbyl9bv3nq8gag4ch3krlas7kjs6f2khq7dm04qyawlxw";
    };
  };
in {
  extraPlugins = [diffchar];
}
