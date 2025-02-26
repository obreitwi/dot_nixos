{
  utils = {
    autoCmdFT = {
      lang,
      command,
    }: {
      event = "FileType";
      pattern = lang;
      inherit command;
    };
  };
}
