{pkgs, ...}: {
  extraPlugins = [
    pkgs.vimPlugins.vim-terraform
  ];

  plugins.lsp.servers.terraformls.enable = true;
}
