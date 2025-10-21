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
in
  writeShellApplication {
    name = "ptpython";
    runtimeInputs = [wrapped];
    text = ''
      ${wrapped}/bin/ptpython "$@"
    '';
  }
