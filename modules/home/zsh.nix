{
  pkgs,
  dot-zsh,
  ...
}: let
  plugins = with pkgs; [
    zsh-autopair
    zsh-autosuggestions
    zsh-forgit
    zsh-fzf-tab
    zsh-history-substring-search
    zsh-nix-shell
    zsh-powerlevel10k
    zsh-vi-mode
  ];

  initPluginsFirst = ''
    source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
  '';

  initPlugins = with pkgs;
    writeText "zsh-init-plugins.sh"
    /*
    sh
    */
    ''
      source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # list of completers to use (does not work correctly)
      # TODO: figure out how to complete on redirect
      zstyle ':completion:*::::' completer _expand _complete _ignored _approximate _redirect

      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false

      # set descriptions format to enable group support
      # NOTE: don't use escape sequences here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'

      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no

      # preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'

      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'

      # apply to all command
      zstyle ':fzf-tab:*' popup-min-size 50 8
      # only apply to 'diff'
      zstyle ':fzf-tab:complete:diff:*' popup-min-size 80 12

      # padding for popup
      zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0

      # resolve issue with carapace
      zstyle ':fzf-tab:*' query-string prefix first

      source ${zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
      autopair-init

      source ${zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

      source ${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      source "${zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh"
      FORGIT_FZF_DEFAULT_OPTS="--preview-window 'down:75%'"
      export FORGIT_FZF_DEFAULT_OPTS

      source ${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      # bindings for history-substring search
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down

      source ${zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
in {
  home.packages = plugins;

  programs.zsh = {
    enable = true;

    history = {
      save = 1000000000;
      size = 1000000000;
      ignoreAllDups = true;
    };

    initExtraFirst =
      initPluginsFirst
      + ''
        ZSH_VIA_NIX=1

        unset ZSH_CFG_ROOT
        source ${dot-zsh}/zshrc
      '';

    initExtra = ''
      source ${initPlugins}
      source ${dot-zsh}/widgets
    '';

    profileExtra = ''
      source ${dot-zsh}/zprofile
    '';

    syntaxHighlighting.enable = true;
  };
}
