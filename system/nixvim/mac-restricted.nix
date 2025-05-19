{
  imports = [
    ./common.nix

    ../../modules/nixvim/
  ];

  my.nixvim = {
    lang = {
      all = false;
      java = true;
    };

    lsp.common = false;
  };
}
