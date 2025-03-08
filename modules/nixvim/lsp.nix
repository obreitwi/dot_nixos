{
  plugins.lsp = {
    enable = true;

    inlayHints = true;

    capabilities =
      /*
      lua
      */
      ''
        capabilities.document_formatting = true
        capabilities.document_range_formatting = true
      '';

    keymaps = {
      diagnostic = {
        "]d" = "goto_next";
        "[d" = "goto_prev";
      };

      extra = [
        {
          key = "[coc]k";
          mode = "n";
          action = "vim.lsp.buf.hover";
        }
        {
          key = "[coc]i";
          mode = "n";
          action = "vim.lsp.buf.implementation";
        }
        {
        mode = ["n" "i"];

        }
        # vim.keymap.set({'n', 'i'}, '<C-k>', vim.lsp.buf.signature_help, opts)
        # -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        # -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        # -- vim.keymap.set('n', '<space>wl', function()
        # --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        # -- end, opts)
        # -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        # vim.keymap.set('n', '[coc]n', vim.lsp.buf.rename, opts)
        # vim.keymap.set({ 'n', 'v' }, '[coc]a', vim.lsp.buf.code_action, opts)
        # -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        # vim.keymap.set('n', '<leader>cf', function()
        # local find_lsp = function(name)
        # return table.getn(
        # vim.lsp.get_active_clients({
        # bufnr = vim.fn.bufnr(),
        # name = name,
        # })
        # ) > 0
        # end
        # local found_eslint = find_lsp('eslint')

        # if found_eslint then
        # vim.cmd('EslintFixAll')
        # else
        # vim.lsp.buf.format { async = true }
        # end
      ];
    };

    onAttach =
      /*
      lua
      */
      ''

      '';
  };

  extraConfigVim =
    /*
    vim
    */
    ''
      function! GenerateProtoRestart()
        exec '!generate-proto'
        LspRestart
      endfunction
      nmap <leader>pr :call GenerateProtoRestart()<CR>
    '';
}
