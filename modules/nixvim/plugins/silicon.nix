{
  config,
  lib,
  pkgs,
  ...
}: let
  nvim-silicon = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-silicon";
    src = pkgs.fetchFromGitHub {
      owner = "michaelrommel";
      repo = "nvim-silicon";
      rev = "7f66bda8f60c97a5bf4b37e5b8acb0e829ae3c32";
      sha256 = "1zk6lgghvdcys20cqvh2g1kjf661q1w97niq5nx1zz4yppy2f9jy";
    };
  };
in {
  options.my.nixvim.silicon.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.nixvim.silicon.enable {
    extraPlugins = [
      nvim-silicon
    ];
  };
}
