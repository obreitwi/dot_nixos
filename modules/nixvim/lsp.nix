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
