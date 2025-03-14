{pkgs, ...}: {
  extraPlugins = [
    pkgs.vimPlugins.vim-mundo
  ];
  extraConfigVim =
    # vim
    ''
      map <leader>mt :MundoToggle<CR>
      let g:mundo_inline_undo=1
    '';
}
