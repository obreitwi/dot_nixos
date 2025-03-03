{pkgs, ...}: {
  extraPlugins = [
    pkgs.vimPlugins.vim-dispatch
    pkgs.vimPlugins.vim-eunuch
    pkgs.vimPlugins.vim-fugitive
    pkgs.vimPlugins.vim-git
    pkgs.vimPlugins.vim-sleuth
    pkgs.vimPlugins.vim-sleuth
    pkgs.vimPlugins.vim-speeddating
    pkgs.vimPlugins.vim-surround
    pkgs.vimPlugins.vim-unimpaired
  ];

  globals.eunuch_no_maps = 1;
}
