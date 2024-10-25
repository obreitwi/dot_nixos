{
  lib,
  config,
  pkgs,
  myUtils,
  ...
}: let
  plugin = pkgs.vimUtils.buildVimPlugin {
    name = "octo";
    src = pkgs.fetchFromGitHub {
      owner = "pwntester";
      repo = "octo.nvim";
      rev = "22f34582a4eb1fb221eafd0daa9eb1b2bacfb813";
      hash = "sha256-QDeJMPBXTexTowQ0MW99Il97GHOCvGXlP2yXM1ZCqv8=";
    };
  };
  config =
    myUtils.vimLua
    /*
    lua
    */
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
      default = true;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf config.my.neovim.octo {
    programs.neovim = {
      plugins = [
        {inherit plugin config;}
      ];
    };
  };
}
