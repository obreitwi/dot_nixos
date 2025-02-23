let
  prefixToKeybinds = {
    key,
    alias,
  }: [
    {
      inherit key;
      action = alias;
      mode = "n";
      options.remap = true;
    }
    {
      key = alias;
      action = "<nop>";
      mode = "n";
    }
  ];

  prefixes = [
    {
      key = "<leader>d";
      alias = "[dbg]";
    }
    {
      key = "<leader>u";
      alias = "[unite]";
    }
    {
      key = "<leader>g";
      alias = "[coc]";
    }
    {
      key = "<leader>a";
      alias = "[ale]";
    }
    {
      key = "<leader>s";
      alias = "[usnips]";
    }
    {
      key = "<leader><leader>";
      alias = "[hop]";
    }
  ];
in {
  keymaps = builtins.concatMap prefixToKeybinds prefixes;
}
