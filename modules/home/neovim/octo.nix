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
      rev = "cdddd801139a3d8b7cdae788e10d4755991a0a11";
      sha256 = "1s25bd2ab28bfkb09j13wkr197pbbqp2257v2g6f3pbambdf6xfa";
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
