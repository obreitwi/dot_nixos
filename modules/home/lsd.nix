{
  config,
  lib,
  ...
}: {
  options.my.lsd.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.lsd.enable) {
    programs.lsd = {
      enable = true;
      settings = {
        truncate-owner = {
          after = 8;
          marker = "…";
        };
      };
    };
  };
}
