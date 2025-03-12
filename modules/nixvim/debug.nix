{pkgs, ...}: let
  messages = pkgs.vimUtils.buildVimPlugin {
    name = "messages.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "AckslD";
      repo = "messages.nvim";
      rev = "24dbb56829d1ed2d8d878e9f5547478441838567";
      sha256 = "114l5pdqx07s34r02qlp92w4nh8y10m1222xfa452ps17dfk83x0";
    };
  };
in {
  extraPlugins = [messages];
}
