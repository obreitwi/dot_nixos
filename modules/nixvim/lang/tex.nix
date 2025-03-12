{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    my.nixvim.tex.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.my.nixvim.tex.enable {
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
          sha256 = "sha256-8kCWoXMAvzUuexxmgX4vADsJrBEwmLtl4QTjNgcujwQ=";
        };
      })
    ];
  };
}
