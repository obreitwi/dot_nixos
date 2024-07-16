{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.work.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.work.enable {
    home.packages = with pkgs; [
      grpcrl
      neorg-task-sync
    ];
  };
}
