{
  lib,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "toggle-external-monitor";
  version = "0.1.0";

  src = ./toggle-external-monitor.c;
  dontUnpack = true;

  buildPhase = ''
    runHook preBuild
    $CC -O2 -Wall -Wextra -o toggle-external-monitor $src -framework CoreGraphics
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 toggle-external-monitor $out/bin/toggle-external-monitor
    runHook postInstall
  '';

  meta = {
    description = "Toggle (disable/enable) the external monitor on macOS";
    platforms = lib.platforms.darwin;
    mainProgram = "toggle-external-monitor";
  };
}
