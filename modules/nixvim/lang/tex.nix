{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.nixvim.lang.tex.disable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all && !config.my.nixvim.lang.tex.disable) {
    plugins.cmp.settings.sources = [{name = "texlab";}];
    plugins.lsp.servers.texlab.enable = true;

    plugins.vimtex = {
      enable = true;
      settings.view_mode = "zathura";
      # texlivePackage = pkgs.texliveFull;
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "vim-grammarous";
        src = pkgs.fetchFromGitHub {
          owner = "rhysd";
          repo = "vim-grammarous";
          rev = "db46357465ce587d5325e816235b5e92415f8c05";
          sha256 = "014g5q3kdqq4w5jvp61h26n0jfq05xz82rhwgcp3bgq0ffhrch7j";
        };
      })
    ];
  };
}
