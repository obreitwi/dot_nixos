{utils, ...}: let
  inherit (utils) autoCmdFT;
in {
  autoCmd = [
    (autoCmdFT {
      lang = "vimwiki";
      command =
        # vim
        "setlocal tabstop=2 | setlocal shiftwidth=2 | setlocal expandtab | setlocal foldlevel=0 | setlocal comments=fb:*,fb:# | setlocal foldminlines=0";
    })
  ];
}
