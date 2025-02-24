{
  imports = [
    ./colorscheme.nix
    ./powersettings.nix
    ./prefix_maps.nix
    ./statusline.nix
    ./syntax.nix
    ./utils.nix

    ./plugins
  ];

  clipboard.providers.xclip.enable = true;

  opts = {
    number = true;
    relativenumber = true;

  };

  globals = {
    mapleader = " ";
    maplocalleader = ";";
  };
}
