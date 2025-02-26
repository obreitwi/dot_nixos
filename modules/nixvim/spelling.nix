{
  keymaps = [
    {
      key = "<f8>";
      mode = "";
      action = ":setlocal spell!<CR>";
    }
  ];
  userCommands = {
    Sp = {
      nargs = 1;
      command = "setlocal spelllang=<args>";
    };
  };
}
