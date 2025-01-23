{
  pkgs,
  pkgs-stable,
  writeShellApplication,
  ...
}: let
  wrepson = ./wrepson.zsh;
in
  writeShellApplication {
    name = "wrepson";
    runtimeInputs = with pkgs; [
      avahi
      coreutils-full
      pkgs-stable.epsonscan2
      jq
      xdg-utils
      zsh
    ];
    text = ''
      zsh ${wrepson} "$@"
    '';
  }
