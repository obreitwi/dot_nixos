{pkgs, ...}: {
  extraPlugins = [
    pkgs.vimPlugins.haskell-tools-nvim
  ];

  extraConfigLua =
    /*
    lua
    */
    ''
      require('haskell-tools')
    '';
}
