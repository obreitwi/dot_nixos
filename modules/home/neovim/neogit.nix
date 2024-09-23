{
  pkgs,
  ...
}: {
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      neogit # required
      diffview-nvim # optional
    ];
  };
}
