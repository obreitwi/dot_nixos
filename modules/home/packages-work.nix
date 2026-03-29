{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkIf config.my.work.enable {
    home.packages = [
      pkgs.citrix_workspace
    ];
  };
}
