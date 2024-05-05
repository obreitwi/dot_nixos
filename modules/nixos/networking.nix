{
  lib,
  config,
  pkgs,
  ...
}: {
  options.my.iwd.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.iwd.enable {
    networking.wireless.iwd.enable = true;

    environment.systemPackages = with pkgs; [
      snixembed # icons in trayer
      iwgtk
    ];
  };
}
