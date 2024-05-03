{
  config,
  lib,
  pkgs,
  ...
}: let
  tmuxPlugins = with pkgs.tmuxPlugins; [sensible yank gruvbox];
in {
  home.packages = with pkgs; [tmux] ++ tmuxPlugins;

  home.file."${config.xdg.configHome}/tmux/load-plugins".text =
    lib.strings.concatMapStrings (p: "run-shell " + p.rtp + "\n") tmuxPlugins;
}
