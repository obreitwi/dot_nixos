{
  imports = [
    ./common.nix

    ../../modules/nixvim/
  ];

  my.nixvim = {
    lang = {
      all = false;

      apl = true;
      java = true;
      typst = true;
    };

    lsp.common = false;

    neorg.enable = true;
  };
}
