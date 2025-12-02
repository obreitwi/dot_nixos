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
      pl1 = true;
      postgres = true;
      python = true;
      typescript = true;
      typst = true;

      angular.disable = false;
    };

    lsp.common = false;

    neorg.enable = lib.mkForce true;
  };

  plugins.lsp.servers.bashls.enable = true;
}
