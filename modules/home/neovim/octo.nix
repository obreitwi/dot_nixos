{
  lib,
  config,
  pkgs,
  myUtils,
  ...
} @ args: let
  plugin = pkgs.vimUtils.buildVimPlugin {
    name = "octo";
    src = pkgs.fetchFromGitHub {
      owner = "pwntester";
      repo = "octo.nvim";
      rev = "340c41f768f9dad3ed8cb52153214509f5cb6d56";
      sha256 = "0cpdcfia5wyxrmjgz22qrf8m1w7sdfk4bxj7c5pzx5j00lsj2mla";
    };
  };
  config =
    myUtils.vimLua
    # lua
    ''
      require("octo").setup({
        default_merge_method = "squash",
        enable_builtin = true,
        use_local_fs = true,
        suppress_missing_scope = {
          projects_v2 = true,
        },
      })
      -- TODO: set mapleader (https://github.com/nix-community/home-manager/pull/2391)
      vim.keymap.set('n', '<space>o', '<cmd>Octo<cr>', {desc = 'Launch Octo'})
    '';
in {
  options.my.neovim = {
    octo = lib.mkOption {
      default = false; # build issue in vimplugin-pathlib.nvim-2.2.3-1.drv
      type = lib.types.bool;
    };
  };

  config = lib.mkIf args.config.my.neovim.octo {
    programs.neovim = {
      plugins = [
        {inherit plugin config;}
      ];
    };
  };
}
