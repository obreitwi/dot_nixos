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

      lspBuf = {
        "[coc]k" = "hover";
        "[coc]i" = "implementation";
        # "[coc]t" = "type_definition"; # handled by telescope
        "<c-k>" = "signature_help";
        "[coc]n" = "rename";
        "[coc]a" = "code_action";
        "<leader>cf" = "format";
      };
    };

    onAttach =
      # lua
      ''
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "[coc]E", vim.diagnostic.open_float, bufopts)
      '';
  };
  plugins.lsp-format.enable = true;
  plugins.lsp-signature.enable = false; # too many error in typesript

  extraConfigVim =
    # vim
    ''
      function! GenerateProtoRestart()
        exec '!generate-proto'
        LspRestart golangci_lint_ls
        LspRestart gopls
      endfunction
      nmap <leader>pr :call GenerateProtoRestart()<CR>
    '';
}
