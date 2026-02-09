{
  config,
  lib,
  ...
}: {
  options.my.nixvim.claude-code.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.nixvim.claude-code.enable {
    plugins.claude-code = {
      enable = true;
    };
  };
}
