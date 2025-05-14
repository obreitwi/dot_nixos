{
  config,
  lib,
  ...
}: {
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

    servers = {
      ast_grep.enable = true;
      bashls.enable = true;
      cssls = {
        enable = false;
        settings.scss.validate = false;
        onAttach.function = "client.server_capabilities.documentFormattingProvider = false";
      };
      dartls.enable = false;
      eslint = {
        enable = true;
        settings.format = true;
      };
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
      postgres_lsp.enable = true;
      protols.enable = true;
      pyright.enable = true;
      pylsp = {
        settings.plugins.black.enable = true;
      };
      stylelint_lsp = {
        enable = true;
        settings = {
          autoFixOnFormat = true;
        };
      };
      ts_ls = {
        enable = true;
        settings.format = false;
      };
      tailwindcss.enable = false;
    };
  };
  plugins.lsp-format.enable = true;
  plugins.lsp-signature.enable = false; # too many error in typesript

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
