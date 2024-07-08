{
  findutils,
  git,
  grpcurl,
  writeShellApplication,
}: let
  toWrap = ./grpcrl.sh;
in
  writeShellApplication {
    name = "grpcrl";
    runtimeInputs = [
      findutils
      git
      grpcurl
    ];
    text = builtins.readFile toWrap;
  }
