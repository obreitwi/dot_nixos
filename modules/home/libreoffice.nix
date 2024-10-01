{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.libreoffice.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.libreoffice.enable {
    home.packages = with pkgs; [
      libreoffice
    ];
  };
}
