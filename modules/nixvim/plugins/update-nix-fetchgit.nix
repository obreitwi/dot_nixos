{pkgs, ...}: {
  extraConfigVim = ''
    " A helper to preserve the cursor location with filters
    function! Preserve(command)
      let w = winsaveview()
      execute a:command
      call winrestview(w)
    endfunction

    " Update fetcher under cursor, note that this might take a little while if the
    " fetched path is large.
    autocmd FileType nix map <nowait> <leader>nu :call Preserve("%!${pkgs.update-nix-fetchgit}/bin/update-nix-fetchgit --location=" . line(".") . ":" . col("."))<CR>
  '';
}
