{
  imports = [
    ./colorscheme.nix
    ./completion.nix
    ./debug.nix
    ./directories.nix
    ./keymaps.nix
    ./local.nix
    ./lsp.nix
    ./lsp-servers.nix
    ./opts.nix
    ./powersettings.nix
    ./prefix_maps.nix
    ./spelling.nix
    ./statusline.nix
    ./syntax.nix

    ./lang
    ./plugins
    ./treesitter
  ];

  clipboard.providers.xclip.enable = true;
}
