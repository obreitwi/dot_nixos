# so far we only need utilities
{
  config,
  pkgs,
  lib,
  ...
}: let
  google-chat = pkgs.writeShellApplication {
    name = "google-chat";
    runtimeInputs = [
      pkgs.picom
      pkgs.glxinfo
    ];
    text = ''
      exec google-chrome --app=https://chat.google.com "$@"
    '';
  };

  google-meet = pkgs.writeShellApplication {
    name = "google-meet";
    text = ''
      exec google-chrome --app=https://meet.google.com "$@"
    '';
  };
in {
  options.my.chrome.utils = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.chrome.utils {
    home.packages = [google-chat google-meet];
  };
}
