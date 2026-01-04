{pkgs, ...}: let
  linediff = pkgs.vimUtils.buildVimPlugin {
    name = "linediff";
    src = pkgs.fetchFromGitHub {
      owner = "AndrewRadev";
      repo = "linediff.vim";
      rev = "29fa617fc10307a1e0ae82a8761114e465d17b06";
      sha256 = "08j35wazl1x6xplwkdd2304h4szanlywl4sgn1cd1wzymnprcxg7";
    };
  };
in {
  extraPlugins = [
    linediff
  ];

  keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>ldd";
      action = "<CMD>Linediff<CR>";
    }
    {
      mode = ["n" "v"];
      key = "<leader>ldr";
      action = "<CMD>LinediffReset<CR>";
    }
  ];
}
