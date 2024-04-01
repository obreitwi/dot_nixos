{
  lib,
  config,
  ...
}: {
  options.my.readline.enable = lib.mkOption {default = true;};

  config = lib.mkIf config.my.readline.enable {
    programs.readline = {
      enable = true;

      variables = {
        show-all-if-ambiguous = true;
        visible-stats = true;
        editing-mode = "vi";
        keymap = "vi";
      };
    };
  };
}
