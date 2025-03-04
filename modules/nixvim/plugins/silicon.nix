{pkgs, ...}: let
  nvim-silicon = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-silicon";
    src = pkgs.fetchFromGitHub {
      owner = "michaelrommel";
      repo = "nvim-silicon";
      rev = "7f66bda8f60c97a5bf4b37e5b8acb0e829ae3c32";
      hash = "sha256-XiYn/L2e/B+6LTjak3jAwRgnZ3gCbsyA0J61Dd+jZv4=";
    };
  };
in {
  extraPlugins = [
    nvim-silicon
  ];
}
