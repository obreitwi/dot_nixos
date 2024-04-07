{
  config,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable; [
   zsh
   zsh-vi-mode
  ];
}
