{
  imports = [
    ./colorscheme.nix
    ./debug.nix
    ./directories.nix
    ./keymaps.nix
    ./lsp.nix
    ./opts.nix
    ./powersettings.nix
    ./prefix_maps.nix
    ./spelling.nix
    ./statusline.nix
    ./syntax.nix

    ./lang
    ./plugins
  ];

  clipboard.providers.xclip.enable = true;
}
