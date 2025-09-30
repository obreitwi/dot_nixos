{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.terraform.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.terraform.enable {
    home.packages = with pkgs; [
      terraform
      terraform-ls
      tfautomv
    ];

    programs.neovim = {
      extraConfig =
        lib.mkAfter
        # vim
        ''
          lua <<EOF
            vim.lsp.config.enable('terraformls')
          EOF
          autocmd BufWritePre *.tfvars lua vim.lsp.buf.format()
          autocmd BufWritePre *.tf lua vim.lsp.buf.format()
        '';
    };
  };
}
