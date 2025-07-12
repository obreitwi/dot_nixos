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
      java = true;
      nix = true;
      postgres = true;
      typescript = true;
      typst = true;
    };

    lsp.common = false;

    neorg.enable = lib.mkForce true;
  };
}
