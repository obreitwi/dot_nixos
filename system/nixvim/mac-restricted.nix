{
  imports = [
    ./common.nix

    ../../modules/nixvim/
  ];

  my.nixvim = {
    lang = {
      all = false;
    };

    lsp.all = false;
  };
}
