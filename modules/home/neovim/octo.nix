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
      rev = "b95f205a0835f8845fef7159a2d0fa229c6f6443";
      sha256 = "1ncqgvkxnhzxzjbw1hs8mml5jffq54zlhi7l35nlkhs19rr2j32z";
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
