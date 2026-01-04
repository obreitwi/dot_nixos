{
  lib,
  config,
  ...
}: {
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
    #./performance.nix
    ./powersettings.nix
    ./prefix_maps.nix
    ./spelling.nix
    ./statusline.nix
    ./syntax.nix

    ./lang
    ./plugins
    ./treesitter
  ];

  options.my.isMacOS = lib.mkEnableOption "Whether or not we run on Mac";

  config = {
    clipboard.providers.xclip.enable = !config.my.isMacOS;
  };
}
