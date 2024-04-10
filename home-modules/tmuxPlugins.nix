{
  config,
  lib,
  pkgs-unstable,
  ...
}: let
  tmuxPlugins = with pkgs-unstable.tmuxPlugins; [sensible yank gruvbox];
in {
  home.packages = with pkgs-unstable; [tmux] ++ tmuxPlugins;

  home.file."${config.xdg.configHome}/tmux/load-plugins".text =
    lib.strings.concatMapStrings (p: "run-shell " + p.rtp + "\n") tmuxPlugins;
}
