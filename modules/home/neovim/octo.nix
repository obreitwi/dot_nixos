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
      rev = "ad981e343c1de1637eaa870be0b5e56be673b1d0";
      sha256 = "12k7x8qab3vkgdbci2xlq8byf12y7hmlaxcm798n6fgimzx1rakz";
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
