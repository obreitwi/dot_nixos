{pkgs, ...}: let
  mySnippets = ./my;
in {
  extraPlugins = [
    pkgs.vimPlugins.ultisnips
    pkgs.vimPlugins.vim-snippets
  ];

  plugins.cmp.settings.sources = [
    {
      name = "ultisnips";
    }
  ];
  extraConfigLua = ''
    vim.opt.runtimepath:append("${mySnippets}")
  '';
  extraConfigVim =
    /*
    vim
    */
    ''
      let g:UltiSnipsExpandTrigger="<c-j>"
      let g:UltiSnipsJumpForwardTrigger="<c-l>"
      let g:UltiSnipsJumpBackwardTrigger="<c-h>"

      map <silent> [usnips]l <Esc>:call UltiSnips#ListSnippets()<CR>
      map <silent> [usnips]e :UltiSnipsEdit<CR>
      let g:UltiSnipsSnippetStorageDirectoryForUltiSnipsEdit="${mySnippets}"
    '';
}
