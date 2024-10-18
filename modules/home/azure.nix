{
  config,
  lib,
  pkgs-pinned,
  ...
}: let
  pkgs = pkgs-pinned;
  azure-cli = pkgs.azure-cli.withExtensions (with pkgs.azure-cli-extensions; [azure-devops fzf rdbms-connect]);
in {
  options.my.azure.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.azure.enable {
    home.packages = [azure-cli];

    programs.zsh.initExtraFirst = ''
      fpath+=(${azure-cli}/share/zsh/site-functions)
    '';
  };
}
