{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.terraform-ls.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.terraform-ls.enable {
    home.packages = with pkgs; [
      terraform-ls
    ];

    programs.neovim = {
      extraConfig =
        lib.mkAfter
        /*
        vim
        */
        ''
          lua <<EOF
            require'lspconfig'.terraformls.setup{}
          EOF
          autocmd BufWritePre *.tfvars lua vim.lsp.buf.format()
          autocmd BufWritePre *.tf lua vim.lsp.buf.format()
        '';
    };
  };
}
