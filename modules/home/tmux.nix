{
  config,
  lib,
  pkgs,
  ...
}: let
  tmuxPlugins = with pkgs.tmuxPlugins; [
    sensible
    yank
    gruvbox
    extrakto
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
