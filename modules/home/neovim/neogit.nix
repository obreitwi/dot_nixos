{
  myUtils,
  pkgs,
  ...
}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      {
        plugin = neogit; # required
        config =
          myUtils.vimLua
          /*
          lua
          */
          ''
            require("neogit").setup()
          '';
      }
      {
        plugin = diffview-nvim; # optional
        config =
          myUtils.vimLua
          /*
          lua
          */
          ''
            require("diffview").setup()
          '';
      }
    ];
  };
}
