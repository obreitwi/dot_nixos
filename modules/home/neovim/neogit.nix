{
  myUtils,
  pkgs,
  ...
}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      neogit # required
      diffview-nvim # optional
    ];
    extraLuaConfig =
      /*
      lua
      */
      ''
        require("neogit").setup()
        require("diffview").setup()
      '';
  };
}
