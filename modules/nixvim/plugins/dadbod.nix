{pkgs, ...}: {
  plugins.vim-dadbod.enable = true;
  plugins.vim-dadbod-ui.enable = true;
  plugins.vim-dadbod-completion.enable = true;

  extraConfigLua = ''
    require "cmp".setup.filetype({ "sql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })
  '';
}
