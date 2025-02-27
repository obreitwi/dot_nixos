{
  plugins.fugitive.enable = true;

  extraConfigVim =
    /*
    vim
    */
    ''
      " Clean git objects when buffer is left
      autocmd BufReadPost fugitive://* set bufhidden=delete
      nnoremap <leader>F :Git<CR>:on<CR>
      nnoremap <leader>fa :Git add %<CR>
      nnoremap <leader>fc q:iGit commit -m ""<Left>
      nnoremap gb :Git blame<CR>
      nnoremap gB :Git blame -CCCw<CR>
    '';
}
