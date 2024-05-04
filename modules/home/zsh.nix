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
    writeText "zsh-init-plugins.sh" ''
      source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      zstyle ":completion:*:git-checkout:*" sort false
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
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
