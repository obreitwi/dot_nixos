{lib, ...}: {
  # TODO: Not working as intended yet, would want this config as prefix for neovim config to set leaders prior to plugin configuration.
  programs.neovim = {
    extraConfig =
      lib.mkBefore
      /*
      vim
      */
      ''
        let mapleader=" "
        let maplocalleader=";"
      '';
  };
}
