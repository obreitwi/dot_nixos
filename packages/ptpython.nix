{
  pkgs,
  writeShellApplication,
  ...
}: let
  wrapped = pkgs.python3.withPackages (ps: [
    ps.numpy
    ps.scipy
    pkgs.python3Packages.ptpython
  ]);

  config = ../config-files/ptpython/config.py;
in
  writeShellApplication {
    name = "ptpython";
    runtimeInputs = [wrapped];
    text = ''
      ${wrapped}/bin/ptpython "--config-file=${config}" "$@"
    '';
  }
