{pkgs, ...}: let
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
  extraPlugins = [
    nvim-silicon
  ];
}
