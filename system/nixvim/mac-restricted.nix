{lib, ...}: {
  imports = [
    ./common.nix

    ../../modules/nixvim
  ];

  my.isMacOS = true;

  my.nixvim = {
    lang = {
      all = false;

      apl = true;
      kotlin = true;
      nix = true;
      postgres = true;
      typescript = true;
      typst = true;

      angular.disable = false;
    };

    lsp.common = false;

    neorg.enable = lib.mkForce true;
  };

  plugins.lsp.servers.bashls.enable = true;
}
