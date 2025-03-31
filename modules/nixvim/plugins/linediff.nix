{pkgs, ...}: let
  linediff = pkgs.vimUtils.buildVimPlugin {
    name = "linediff";
    src = pkgs.fetchFromGitHub {
      owner = "AndrewRadev";
      repo = "linediff.vim";
      rev = "ddae71ef5f94775d101c1c70032ebe8799f32745";
      sha256 = "01dshpxm1svfhw9l447mz224qbvlbvywd7ai4wxwyjzgkhp36937";
    };
  };
in {
  extraPlugins = [
    linediff
  ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>ldd";
      action = "<CMD>Linediff<CR>";
    }
    {
      mode = "n";
      key = "<leader>ldr";
      action = "<CMD>LinediffReset<CR>";
    }
  ];
}
