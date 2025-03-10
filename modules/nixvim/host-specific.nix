{
 hostname, ...
}: {
  my.nixvim = {
    tex.enable = builtins.elem hostname ["mucku"];
  };
}
