{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
   zsh
   zsh-vi-mode
  ];
}
