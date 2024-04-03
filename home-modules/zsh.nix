{
  config,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable; [
   zsh
   zsh-vi-mode
  ];

  home.file."${config.home.homeDirectory}/.zsh/plugins/zsh-vi-mode.plugin.zsh".source = "${pkgs-unstable.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
}
