{utils, ...}: let
  inherit (utils) autoCmdFT;
in {
  autoCmd = [
    (
      autoCmdFT {
        lang = "go";
        command = "setlocal spelloptions+=noplainbuffer";
      }
    )
  ];
}
