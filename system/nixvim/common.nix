{hostname ? null, ...}: {
  my.nixvim = {
    lang.all = builtins.elem hostname ["mimir" "minir" "mucku"];
    lang.tex.disable = !builtins.elem hostname ["mucku"];
    lsp.common = builtins.elem hostname ["mimir" "minir" "mucku"];
    neorg.enable = builtins.elem hostname ["mimir" "minir"];
    silicon.enable = builtins.elem hostname ["mimir" "minir" "mucku"];
  };
}
