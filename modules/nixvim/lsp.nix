{
  plugins.lsp = {
    enable = true;

    inlayHints = true;

    capabilities =
      # lua
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
          key = "<c-k>";
          mode = [
            "n"
            "i"
          ];
          action = "vim.lsp.buf.signature_help";
        }
        # -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        # -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        # -- vim.keymap.set('n', '<space>wl', function()
        # --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        # -- end, opts)
        # -- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        {
          key = "[coc]n";
          mode = "n";
          action = "vim.lsp.buf.rename";
        }
        {
          key = "[coc]a";
          mode = [
            "n"
            "v"
          ];
          action = "vim.lsp.buf.code_action";
        }
        {
          key = "<leader>cf";
          mode = ["n"];
          action = "vim.lsp.buf.format({ async = true })";
        }
        # -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        # vim.keymap.set('n', '<leader>cf', function()
        # local find_lsp = function(name)
        # return table.getn(
        #. vim.lsp.get_active_clients({
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

    servers = {
      ast_grep.enable = true;
      bashls.enable = true;
      cssls.enable = true;
      dartls.enable = false;
      eslint = {
        enable = true;
        settings.format = true;
      };
      golangci_lint_ls.enable = true;
      gopls.enable = true;
      lua_ls.enable = true;
      marksman.enable = true;
      nixd = {
        enable = true;
        settings = {
          diagnostic.suppress = ["sema-escaping-with"];
          formatting.command = [
            "alejandra"
            "-qq"
          ];
          nixpkgs.expr = "import <nixpkgs> {}";
          options = {
            nixos = {
              expr = ''(builtins.getFlake "$FLAKE").nixosConfigurations.gentian.options'';
            };
            home_manager = {
              expr = ''(builtins.getFlake "$FLAKE").homeConfigurations."oliver.breitwieser@mimir".options'';
            };
          };
        };
      };
      nushell.enable = false;
      pyright.enable = true;
      pylsp = {
        settings.plugins.black.enable = true;
      };
      texlab.enable = false;
      ts_ls = {
        enable = true;
        settings.format = false;
      };
      tailwindcss.enable = false;
    };
  };

  extraConfigVim =
    # vim
    ''
      function! GenerateProtoRestart()
        exec '!generate-proto'
        LspRestart
      endfunction
      nmap <leader>pr :call GenerateProtoRestart()<CR>
    '';
}
