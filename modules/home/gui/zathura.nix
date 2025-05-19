{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.zathura.enable = lib.mkOption {
    default = true;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.gui.enable && config.my.zathura.enable) {
    programs.zathura = {
      enable = true;

      extraConfig = ''
        set sandbox none
        set synctex true
      '';

      options = {
        adjust-open = "best-fit";
        database = "sqlite";
        synctex-editor-command = "nvr --remote-silent +\%{line}|foldo\! \%{input}";
        vertical-center = true;
      };

      mappings = {
        D = "set \"first-page-column 1:1\"";
        "<C-d>" = "set \"first-page-column 1:2\"";
      };
    };
  };
}
