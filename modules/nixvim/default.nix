{
  imports = [
    ./gruvbox.nix
    ./lualine.nix
    ./powersettings.nix
    ./syntax.nix
    ./utils.nix
  ];

  clipboard.providers.xclip.enable = true;

  opts = {
    number = true;
    relativenumber = true;
  };
}
