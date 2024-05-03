{
  config,
  lib,
  pkgs,
  ...
}: let
  azure-cli = pkgs.azure-cli.withExtensions (with pkgs.azure-cli-extensions; [azure-devops fzf]);
in {
  home.packages = [azure-cli];

  programs.zsh.initExtraFirst = ''
    fpath+=(${azure-cli}/share/zsh/site-functions)
  '';
}
