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

  config = lib.mkIf config.my.zathura.enable {
    programs.zathura = {
      enable = true;

      extraConfig = ''
        set adjust-open "best-fit"
        set vertical-center true
        set sandbox none
        set synctex true
        set synctex-editor-command "nvr --remote-silent +\%{line}|foldo\! \%{input}"
      '';

      mappings = {
        D = "set \"first-page-column 1:1\"";
        "<C-d>" = "set \"first-page-column 1:2\"";
      };
    };
  };
}
