{
  imports = [
    ./common.nix

    ../../modules/nixvim
  ];

  clipboard.providers.xclip.enable = true;
}
