{
  config,
  pkgs,
  dot-zsh,
  ...
}: {
  home.packages = with pkgs; [
   zsh
   zsh-vi-mode
   zsh-forgit
  ];

  programs.zsh = {
    enable = true;

    initExtraFirst = /* zsh */ ''
        if [ -e $HOME/git/toolbox/zsh/zshrc ]; then
          source $HOME/git/toolbox/zsh/zshrc
        else
          # still has packaged plugins as submodules -> needs to be fixed
          source ${dot-zsh}/zshrc
        fi
    '';
  };
}
