{
  plugins.hop.enable = true;
  keymaps = [
    {
      key = "[hop]w";
      action = ":HopWordAC<CR>";
    }
    {
      key = "[hop]b";
      action = ":HopWordBC<CR>";
    }
    {
      key = "[hop]/";
      action = ":HopPatternAC<CR>";
    }
    {
      key = "[hop]?";
      action = ":HopPatternBC<CR>";
    }
    {
      key = "[hop]f";
      action = ":HopChar1AC<CR>";
    }
    {
      key = "[hop]F";
      action = ":HopChar1BC<CR>";
    }
    {
      key = "[hop]c";
      action = ":HopChar2AC<CR>";
    }
    {
      key = "[hop]C";
      action = ":HopChar2BC<CR>";
    }
  ];
}
