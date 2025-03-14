{utils, ...}: let
  inherit (utils) autoCmdFT;
in {
  autoCmd = [
    (autoCmdFT {
      lang = "cpp";
      command = "setlocal cinoptions=g0,hs,N-s,+0";
    })
  ];
}
