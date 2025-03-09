{
  plugins = {
    cmp = {
      enable = true;
      settings = {
        sources = [
          {
            name = "nvim_lsp";
          }
          {
            name = "nvim_lua";
          }
          # {
          # name = "luasnip";
          # }
          {
            name = "ultisnips";
          }
          {
            name = "buffer";
          }
        ];
      };
    };
  };
}
