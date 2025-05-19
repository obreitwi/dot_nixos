{hostname ? null, ...}: {
  my.nixvim = {
    lang.all = builtins.elem hostname ["mimir" "mucku"];
    lang.tex.disable = !builtins.elem hostname ["mucku"];
    lsp.common = builtins.elem hostname ["mimir" "mucku"];
    neorg.enable = builtins.elem hostname ["mimir"];
    silicon.enable = builtins.elem hostname ["mimir" "mucku"];
  };
}
