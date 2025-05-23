{
  imports = [
    ./common.nix

    ../../modules/nixvim/
  ];

  my.nixvim = {
    lang = {
      all = false;
      java = true;
      typst = true;
    };

    lsp.common = false;
  };
}
