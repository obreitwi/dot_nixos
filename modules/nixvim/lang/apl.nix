{
  lib,
  config,
  pkgs,
  ...
}: let
  apl-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "apl.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "obreitwi";
      repo = "apl.nvim";
      rev = "495cb672a4db2bc219a33f6e3d7beb7e46011516";
      hash = "sha256-Z1RY9TuBC0FrTKjOPimrhJHVDiln6rECZ1uaoQqj/UQ=";
    };
  };
in {
  options.my.nixvim.lang.apl = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.apl) {
    extraPlugins = [apl-nvim];
  };
}
