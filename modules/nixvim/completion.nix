{
  plugins = {
    cmp = {
      enable = true;
      settings = {
        mapping.__raw = ''cmp.mapping.preset.insert({
              ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
              ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
              -- C-b (back) C-f (forward) for snippet placeholder navigation.
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              },
              ['<Tab>'] = cmp.mapping(function(fallback)
                require("cmp_nvim_ultisnips.mappings").expand_or_jump_forwards(fallback)
              end, { 'i', 's' }),
              ['<S-Tab>'] = cmp.mapping(function(fallback)
                require("cmp_nvim_ultisnips.mappings").jump_backwards(fallback)
              end, { 'i', 's' }),
            })'';

        experimental = {
          native_menu = false;
        };

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
        snippet.expand =
          /*
          lua
          */
          ''function(args) vim.fn["UltiSnips#Anon"](args.body) end'';

        window = {
          completion.border = "rounded";
          documentation.border = "rounded";
        };
      };
    };
  };
}
