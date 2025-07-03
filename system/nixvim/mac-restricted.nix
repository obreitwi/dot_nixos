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
      typst = true;
    };

    lsp.common = false;

    neorg.enable = lib.mkForce true;
  };
}
