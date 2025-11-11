{
  lib,
  pkgs,
  ...
}: let
  tmuxPlugins = with pkgs.tmuxPlugins; [
    extrakto
    fingers
    gruvbox
    sensible
    tmux-fzf
    yank
  ];
in {
  home.packages = with pkgs; [tmux] ++ tmuxPlugins;

  xdg.configFile."tmux/tmux.conf".source = ../../config-files/tmux/tmux.conf;

  xdg.configFile."tmux/plugins.conf".text =
    lib.strings.concatMapStrings (
      p: "run-shell " + p.rtp + "\n"
    )
    tmuxPlugins;

  xdg.configFile."tmux/generated.conf".text =
    /*
    conf
    */
    ''
      bind-key "C-s" run-shell "${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/session.sh switch"
    '';
}
