{
  dot-zsh,
  lib,
  pkgs,
  ...
}: let
  loadSystemdEnv = pkgs.writeShellScript "load-systemd-env" ''
    comm -13 <(env | sort) <(systemctl show-environment --user | sort) | grep -v '^\(NIX_PATH\|INFOPATH\|PATH\|LD_LIBRARY_PATH\)=' | sed 's:^:export :g'
  '';

  initPluginsFirst = ''
    source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
  '';

  initPlugins = with pkgs;
    writeText "zsh-init-plugins.sh"
    # sh
    ''
       source ${zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
       zvm_after_init_commands+=( 'command -v fzf-share >/dev/null && source "$(fzf-share)/completion.zsh" && source "$(fzf-share)/key-bindings.zsh"' )

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

      source "${zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh"
      autopair-init

      source "${zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh"

      source "${zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

      source "${zsh-forgit}/share/zsh/zsh-forgit/forgit.plugin.zsh"
      FORGIT_FZF_DEFAULT_OPTS="--preview-window 'down:75%'"
      export FORGIT_FZF_DEFAULT_OPTS

      source ${zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
      # bindings for history-substring search
      bindkey -M vicmd 'k' history-substring-search-up
      bindkey -M vicmd 'j' history-substring-search-down
    '';

  initCarapace =
    # sh
    ''
      source <(carapace az zsh)
    '';
in {
  home.packages = [pkgs.carapace];

  programs.zsh = {
    enable = true;

    history = {
      save = 1000000000;
      size = 1000000000;
      ignoreAllDups = true;
      share = false; # handled in dot-zsh via INC_APPEND_HISTORY
    };

    initContent = lib.mkMerge [
      (
        lib.mkBefore (
          /*
          zsh
          */
          ''
            if [ -n "''${ZSH_ENABLE_PROFILING:-}" ]; then
            zmodload zsh/zprof
            fi
          ''
          + initPluginsFirst
          +
          # sh
          ''
            ZSH_VIA_NIX=1

            if command -v load-systemd-env &>/dev/null; then
            source <(load-systemd-env)
            fi

            unset ZSH_CFG_ROOT
            source ${dot-zsh}/zshrc
          ''
          + initCarapace
        )
      )
      (
        lib.mkOrder 900
        # sh
        ''
          source ${initPlugins}
          source ${dot-zsh}/widgets
        ''
      )
      (
        lib.mkOrder 2000 # should be highest order
        
        /*
        zsh
        */
        ''
          source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

          if [ -n "''${ZSH_ENABLE_PROFILING:-}" ]; then
            zprof
          fi
        ''
      )
    ];

    profileExtra =
      (
        if pkgs.stdenv.system == "x86_64-linux"
        then ''
          source <(${loadSystemdEnv})
        ''
        else ""
      )
      + ''
        source ${dot-zsh}/zprofile
      '';

    syntaxHighlighting.enable = true;

    # Already called in my zshrc
    completionInit = "";
  };
}
