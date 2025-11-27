{
  lib,
  config,
  pkgs,
  ...
}: let
  pl1-vim = pkgs.vimUtils.buildVimPlugin {
    name = "PLI-Tools";
    src = pkgs.fetchFromGitHub {
      owner = "vim-scripts";
      repo = "PLI-Tools";
      rev = "63066806c0521e345422f864905059d0d46dc052";
      hash = "sha256-awramHcSqv6IeHIKsMsotBrEUgt09938SWoKzzWFpIY=";
    };

    postInstall = ''
      find $out -type f -exec "${pkgs.dos2unix}/bin/dos2unix" -f '{}' \;

      sed -i 's:call VarTab_SetStops:" \0:g' $out/ftplugin/PLI.VIM
    '';
  };
in {
  options.my.nixvim.lang.pl1 = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf (config.my.nixvim.lang.all || config.my.nixvim.lang.pl1) {
    extraPlugins = [pl1-vim];
  };
}
