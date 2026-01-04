{pkgs, ...}: let
  diffchar = pkgs.vimUtils.buildVimPlugin {
    name = "diffchar";
    src = pkgs.fetchFromGitHub {
      owner = "rickhowe";
      repo = "diffchar.vim";
      rev = "14fc3fc79356d6b80462df8dbc8934f293145b9a";
      sha256 = "0njkv16305vdh8vzhxgpvpf70ijhj1pzyjc8vpnnfxcpszz6bf6d";
    };
  };
in {
  extraPlugins = [diffchar];
}
