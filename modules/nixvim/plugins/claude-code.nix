{
  config,
  lib,
  ...
}: {
  options.my.nixvim.claude-code.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.nixvim.neorg.enable {
    plugins.claude-code = {
      enable = true;
    };
  };
}
