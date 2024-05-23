{
  pkgs,
  writeShellApplication,
  ...
}: let
  wrepson = ./wrepson.zsh;
in
  writeShellApplication {
    name = "wrepson";
    runtimeInputs = with pkgs; [
      coreutils-full
      epsonscan2
      jq
      xdg-utils
      zsh
    ];
    text = ''
      zsh ${wrepson} "$@"
    '';
  }
