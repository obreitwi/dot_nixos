{pkgs, ...}: let
  messages = pkgs.vimUtils.buildVimPlugin {
    name = "messages.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "AckslD";
      repo = "messages.nvim";
      rev = "24dbb56829d1ed2d8d878e9f5547478441838567";
      sha256 = "sha256-oA80XTtBX1GIcl0IESoIHkFLuEiXYgEyGfqAjtstlIQ=";
    };
  };
in {
  extraPlugins = [messages];
}
