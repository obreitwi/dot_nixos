{
  config,
  lib,
  pkgs,
  ...
}: let
  tmuxPlugins = with pkgs.tmuxPlugins; [
    extrakto
    fingers
    gruvbox
    sensible
    yank
  ];
in {
  home.packages = with pkgs; [tmux] ++ tmuxPlugins;

  xdg.configFile."tmux/tmux.conf".source = ../../config-files/tmux/tmux.conf;

  xdg.configFile."tmux/load-plugins".text =
    lib.strings.concatMapStrings (
      p: "run-shell " + p.rtp + "\n"
    )
    tmuxPlugins;
}
