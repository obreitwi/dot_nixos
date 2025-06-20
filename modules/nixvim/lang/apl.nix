{
  lib,
  config,
  pkgs,
  ...
}: let
  apl-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "apl.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "salkin-mada";
      repo = "apl.nvim";
      rev = "7d033f0b5b1fb1a5474e5ebed69d0afe9b4a935b";
      hash = "sha256-uF4Ao9/oT/Hr79Lepkxv6IZG2wfqCZFsgKzXPk0mt7Q=";
    };
  };
in {
  options.my.nixvim.lang.apl = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.apl) {
    extraPlugins = [apl-nvim];
  };
}
