{
  utils = let
    autoCmdFT = {
      lang,
      command,
    }: {
      event = "FileType";
      pattern = lang;
      inherit command;
    };
  in {
    inherit autoCmdFT;

    autoCmdsFT = {lang}:
      map
      (
        command:
          autoCmdFT {
            lang = lang;
            inherit command;
          }
      );
  };
}
