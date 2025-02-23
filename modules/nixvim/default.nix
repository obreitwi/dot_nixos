{
  imports = [
    ./gruvbox.nix
    ./lualine.nix
    ./powersettings.nix
  ];

  clipboard.providers.xclip.enable = true;

  opts = {
    number = true;
    relativenumber = true;
  };
}
