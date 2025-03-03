{pkgs, ...}: {
  extraPlugins = [
    pkgs.vimPlugins.vista-vim
  ];
  keymaps = [
    {
      mode = "n";
      key = "<c-y>";
      action = "<CMD>Vista<CR>";
    }
  ];
}
