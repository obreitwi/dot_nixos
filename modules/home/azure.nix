{
  config,
  lib,
  pkgs,
  hostname,
  ...
}: let
  hosts-enabled = ["mimir"];

  azure-cli = pkgs.azure-cli.withExtensions (with pkgs.azure-cli-extensions; [azure-devops fzf]);
in {
  options.my.azure.enable = lib.mkOption {
    default = builtins.elem hostname hosts-enabled;
    type = lib.types.bool;
  };

  config = lib.mkIf config.my.azure.enable {
    home.packages = [azure-cli];

    programs.zsh.initExtraFirst = ''
      fpath+=(${azure-cli}/share/zsh/site-functions)
    '';
  };
}
